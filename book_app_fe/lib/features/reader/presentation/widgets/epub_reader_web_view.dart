import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
  _EpubReaderWebViewState createState() => _EpubReaderWebViewState();
}

class _EpubReaderWebViewState extends State<EpubReaderWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // 1. Instantiate the controller
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          // 2. Add the 'Flutter' channel
          ..addJavaScriptChannel(
            'Console', // numele canalului
            onMessageReceived: (msg) {
              debugPrint("📦 [WebView console] ${msg.message}");
            },
          )
          // 3. Hook page-finished to kick off EPUB loading
          ..setNavigationDelegate(
            NavigationDelegate(onPageFinished: (_) => _loadEpub()),
          )
          // 4. Load your HTML scaffold from assets
          ..loadFlutterAsset('assets/epub_reader.html');

    // NOTE: you no longer do `WebView.platform = ...` here :contentReference[oaicite:0]{index=0}
  }

  void _loadEpub() async {
    debugPrint('Loading EPUB from path: ${widget.epubFilePath}');
    final file = File(widget.epubFilePath);
    final exists = await file.exists();
    debugPrint('  → File exists? $exists');
    if (!exists) {
      // bail out early so you’ll see the error in your Dart log
      return;
    }

    final bytes = await file.readAsBytes();
    final b64 = base64Encode(bytes);
    _controller.runJavaScript('openBookData("$b64", "${widget.initialCfi}");');
  }

  /// Call this to change the font size inside the WebView
  void adjustFontSize(double size) {
    _controller.runJavaScript('adjustFontSize($size);');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: _controller));
  }
}
