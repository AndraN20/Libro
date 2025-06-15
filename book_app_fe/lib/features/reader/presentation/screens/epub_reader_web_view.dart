import 'dart:convert';
import 'dart:io';

import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/progress/domain/models/progress.dart';
import 'package:book_app/features/progress/presentation/viewmodels/reader_progress_provider.dart';
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

  bool showOverlay = false;
  late bool _hasProgress;

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
                if (json is Map && json['cfi'] != null) {
                  _currentCfi = json['cfi'] as String;
                  // debugPrint("🌈 CFI updated: $_currentCfi");
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

  Future<void> _saveProgress() async {
    if (_currentCfi == null || _currentCfi!.isEmpty) return;

    final repo = ref.read(progressRepositoryProvider);
    final progress = Progress(
      epubCfi: _currentCfi!,
      lastReadAt: DateTime.now(),
      status: ReadingStatus.inProgress,
    );

    try {
      if (!_hasProgress) {
        print("📘 Se face POST!");
        await repo.createProgress(bookId: widget.bookId, progress: progress);
        setState(() {
          _hasProgress = true;
        });
      } else {
        print("📗 Se face PATCH!");
        await repo.updateProgress(bookId: widget.bookId, progress: progress);
      }
    } catch (e) {
      debugPrint("❌ Failed to save progress: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveProgress();
        return true;
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
                                await _saveProgress();
                                if (context.mounted) context.pop(true);
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
            ],
          ),
        ),
      ),
    );
  }
}
