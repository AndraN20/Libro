import 'dart:convert';
import 'dart:io';

import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/reader/presentation/widgets/reader_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EpubReaderWebView extends StatefulWidget {
  final String epubFilePath;
  final String initialCfi;

  const EpubReaderWebView({
    required this.epubFilePath,
    this.initialCfi = "",
    Key? key,
  }) : super(key: key);

  @override
  State<EpubReaderWebView> createState() => _EpubReaderWebViewState();
}

class _EpubReaderWebViewState extends State<EpubReaderWebView> {
  late final WebViewController _controller;

  double _fontSize = 16;
  String _fontFamily = 'serif';
  Color _bgColor = Colors.white;

  bool showOverlay = false;

  @override
  void initState() {
    super.initState();

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
              switch (msg.message) {
                case 'back':
                  context.pop();
                  break;
                case 'openSettings':
                  _openSettings();
                  break;
                default:
                // Future support for CFI position
              }
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

    await _controller.runJavaScript(
      'openBookData("$b64", "${widget.initialCfi}");',
    );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            onPressed: () => context.pop(),
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
    );
  }
}
