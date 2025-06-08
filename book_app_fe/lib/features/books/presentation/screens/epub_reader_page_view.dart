import 'package:book_app/core/utils/epub_utils.dart';
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

    setState(() {
      htmlPages = extractedPages;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: PageView.builder(
        itemCount: htmlPages.length,
        itemBuilder: (context, index) {
          return SafeArea(
            child: SizedBox.expand(
              child: Html(data: htmlPages[index], shrinkWrap: false),
            ),
          );
        },
      ),
    );
  }
}
