import 'dart:convert';
import 'dart:io';
import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/progress/domain/models/progress.dart';
import 'package:book_app/features/progress/presentation/viewmodels/reader_progress_provider.dart';
import 'package:book_app/features/progress/presentation/widgets/reader_progress_bar.dart';
import 'package:book_app/features/reader/presentation/widgets/reader_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EpubReaderWebView extends ConsumerStatefulWidget {
  final String epubFilePath;
  final String initialCfi;
  final int bookId;
  final bool hasProgress;

  const EpubReaderWebView({
    required this.epubFilePath,
    required this.bookId,
    this.initialCfi = "",
    this.hasProgress = false,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EpubReaderWebView> createState() => _EpubReaderWebViewState();
}

class _EpubReaderWebViewState extends ConsumerState<EpubReaderWebView> {
  late final WebViewController _controller;
  String? _currentCfi;
  double _fontSize = 16;
  String _fontFamily = 'serif';
  Color _bgColor = Colors.white;
  double _percentage = 0.0;
  int _page = 1;
  int _totalPages = 1;
  String _chapter = "";
  List<Map<String, dynamic>> _chapters = [];
  String _bookText = "";
  bool showOverlay = false;
  late bool _hasProgress;
  bool _waitingForRecap = false;

  @override
  void initState() {
    super.initState();

    _hasProgress = widget.hasProgress;

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'Console',
            onMessageReceived: (msg) {
              debugPrint("📦 [WebView console] ${msg.message}");
            },
          )
          ..addJavaScriptChannel(
            'Flutter',
            onMessageReceived: (msg) {
              try {
                final json = jsonDecode(msg.message);
                if (json is Map) {
                  if (json['bookText'] != null) {
                    setState(() {
                      _bookText = json['bookText'] as String? ?? "";
                    });
                    print("Book text loaded. Length: ${_bookText.length}");
                  }
                  if (_waitingForRecap) {
                    _waitingForRecap = false;
                    if (context.mounted) {
                      context.push('/recap', extra: _bookText);
                    }
                  }
                  if (json['cfi'] != null) {
                    _currentCfi = json['cfi'] as String;
                    setState(() {
                      _percentage =
                          (json['percentage'] as num?)?.toDouble() ?? 0.0;
                      _page = (json['page'] as num?)?.toInt() ?? 1;
                      _totalPages = (json['totalPages'] as num?)?.toInt() ?? 1;
                      if (json['chapter'] != null) {
                        _chapter = json['chapter'] as String;
                      }
                    });
                  }
                  // <-- Prinde TOC-ul!
                  if (json['toc'] != null) {
                    setState(() {
                      _chapters = List<Map<String, dynamic>>.from(json['toc']);
                    });
                  }
                }
              } catch (_) {}
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(onPageFinished: (_) => _loadEpub()),
          )
          ..loadFlutterAsset('assets/epub_reader.html');
  }

  Future<void> _loadEpub() async {
    setState(() {
      _bookText = "";
    });
    final file = File(widget.epubFilePath);
    if (!await file.exists()) return;
    final bytes = await file.readAsBytes();
    final b64 = base64Encode(bytes);

    final jsCall =
        widget.initialCfi.isEmpty
            ? 'openBookData("$b64")'
            : 'openBookData("$b64", "${widget.initialCfi}")';

    await _controller.runJavaScript(jsCall);

    final bgHex =
        '#${_bgColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
    await _controller.runJavaScript(
      'applySettings($_fontSize, "$_fontFamily", "$bgHex");',
    );
  }

  void _openChaptersSheet() {
    if (_chapters.isEmpty) {
      print('TOC gol!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nu s-au putut încărca capitolele.")),
      );
      return;
    } else {
      print('TOC incarcat: $_chapters');
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          itemCount: _chapters.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            final chapter = _chapters[index];
            return ListTile(
              title: Text(
                chapter['label'] ?? "Untitled",
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                print('Capitol selectat: $chapter');
                Navigator.pop(context);
                final href = chapter['href'];
                if (href != null && href.isNotEmpty) {
                  final hrefJs = jsonEncode(href);
                  _controller.runJavaScript('rendition.display($hrefJs)');
                } else {
                  print("Href lipsă sau gol pentru capitolul: $chapter");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Nu există link pentru acest capitol."),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder:
          (_) => ReaderSettingsDialog(
            initialFontSize: _fontSize,
            initialFontFamily: _fontFamily,
            initialBgColor: _bgColor,
            onSettingsChanged: (fontSize, fontFamily, bgColor) {
              _fontSize = fontSize;
              _fontFamily = fontFamily;
              _bgColor = bgColor;
              final bgHex =
                  '#${bgColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';
              _controller.runJavaScript(
                'applySettings($fontSize, "$fontFamily", "$bgHex");',
              );
            },
          ),
    );
  }

  Future<bool> _saveProgress() async {
    if (_currentCfi == null || _currentCfi!.isEmpty) return false;

    final repo = ref.read(progressRepositoryProvider);

    final isCompleted = _percentage >= 0.95;

    final progress = Progress(
      epubCfi: _currentCfi!,
      lastReadAt: DateTime.now(),
      status: isCompleted ? ReadingStatus.completed : ReadingStatus.inProgress,
      percentage: _percentage,
    );

    try {
      if (!_hasProgress) {
        await repo.createProgress(bookId: widget.bookId, progress: progress);
        setState(() {
          _hasProgress = true;
        });
      } else {
        await repo.updateProgress(bookId: widget.bookId, progress: progress);
      }
      return true;
    } catch (e) {
      debugPrint("❌ Failed to save progress: $e");
      return false;
    }
  }

  void _handleBookRecap() async {
    _waitingForRecap = true;
    await _controller.runJavaScript('sendBookTextToFlutter()');
    // Navigarea va fi declanșată automat când bookText ajunge pe canal
  }

  @override
  void didUpdateWidget(covariant EpubReaderWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.epubFilePath != widget.epubFilePath) {
      setState(() {
        _bookText = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final saved = await _saveProgress();
        if (context.mounted) context.pop(saved);
        return false;
      },
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (details) {
            if (details.pointerCount == 2) {
              setState(() => showOverlay = true);
            }
          },
          onTap: () {
            setState(() => showOverlay = false);
          },
          child: Stack(
            children: [
              SafeArea(child: WebViewWidget(controller: _controller)),
              if (showOverlay)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => setState(() => showOverlay = false),
                    child: const SizedBox.expand(),
                  ),
                ),
              if (showOverlay)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.lightPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.darkPurple,
                              ),
                              onPressed: () async {
                                final saved = await _saveProgress();
                                if (context.mounted) context.pop(saved);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: AppColors.darkPurple,
                              ),
                              onPressed: _openSettings,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (showOverlay)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 32,
                  child: BookProgressBar(
                    chapter: _chapter,
                    page: _page,
                    totalPages: _totalPages,
                    percentage: _percentage,
                    onBookRecap: _handleBookRecap,
                    onChapters: _openChaptersSheet,
                    bookText: _bookText,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
