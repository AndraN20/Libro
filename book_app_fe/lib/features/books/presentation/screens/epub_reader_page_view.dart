import 'package:book_app/core/utils/epub_utils.dart';
import 'package:book_app/features/reader/presentation/widgets/reader_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:epubx/epubx.dart';
import 'dart:typed_data';

class EpubReaderPageView extends StatefulWidget {
  final Uint8List epubBytes;

  const EpubReaderPageView({super.key, required this.epubBytes});

  @override
  State<EpubReaderPageView> createState() => _EpubReaderPageViewState();
}

class _EpubReaderPageViewState extends State<EpubReaderPageView> {
  List<String> htmlPages = [];
  bool loading = true;

  // variabile de control
  bool showOverlay = false;
  double fontSize = 16;
  String fontFamily = 'serif';
  Color bgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    final book = await EpubReader.readBook(widget.epubBytes);

    final Set<String> uniqueHtmlSet = {};
    final List<String> extractedPages = [];

    if (book.Chapters != null && book.Chapters!.isNotEmpty) {
      for (var chapter in book.Chapters!) {
        collectChapters(chapter, uniqueHtmlSet, extractedPages);
      }
    } else {
      collectSpineContent(book, uniqueHtmlSet, extractedPages);
    }

    if (!mounted) return;
    setState(() {
      htmlPages = extractedPages;
      loading = false;
    });
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder:
          (_) => ReaderSettingsDialog(
            initialFontSize: fontSize,
            initialFontFamily: fontFamily,
            initialBgColor: bgColor,
            onSettingsChanged: (newSize, newFont, newBg) {
              if (!mounted) return;
              setState(() {
                fontSize = newSize;
                fontFamily = newFont;
                bgColor = newBg;
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: GestureDetector(
        // detectăm pinch
        onScaleStart: (_) => setState(() => showOverlay = true),
        onTap: () {
          // dacă dai tap în rest, ascundem overlay-ul
          if (showOverlay) setState(() => showOverlay = false);
        },
        child: Stack(
          children: [
            // paginile epub
            PageView.builder(
              itemCount: htmlPages.length,
              itemBuilder: (context, index) {
                return SafeArea(
                  child: Container(
                    color: bgColor,
                    child: Html(
                      data: htmlPages[index],
                      style: {
                        'body': Style(
                          fontSize: FontSize(fontSize),
                          fontFamily: fontFamily,
                        ),
                      },
                    ),
                  ),
                );
              },
            ),

            // overlay-ul sus
            if (showOverlay)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    color: Colors.black54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // back
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        // settings
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: _openSettings,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
