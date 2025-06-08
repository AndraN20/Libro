import 'package:epubx/epubx.dart';
import 'html_pagination.dart';

void collectChapters(
  EpubChapter chapter,
  Set<String> uniqueHtmlSet,
  List<String> pagesList,
) {
  final html = chapter.HtmlContent;
  if (html != null && html.trim().isNotEmpty) {
    final cleaned = html.trim();
    if (uniqueHtmlSet.add(cleaned)) {
      final pages = paginateByParagraphsOnly(cleaned);
      pagesList.addAll(pages);
    }
  }

  if (chapter.SubChapters != null) {
    for (final sub in chapter.SubChapters!) {
      collectChapters(sub, uniqueHtmlSet, pagesList);
    }
  }
}

void collectSpineContent(
  EpubBook book,
  Set<String> uniqueHtmlSet,
  List<String> extractedPages,
) {
  final spine = book.Content?.Html;
  if (spine == null || spine.isEmpty) return;

  for (var item in spine.values) {
    final html = item.Content;
    if (html != null && html.trim().isNotEmpty) {
      final cleaned = html.trim();
      if (uniqueHtmlSet.add(cleaned)) {
        final pages = paginateByParagraphsOnly(cleaned);
        extractedPages.addAll(pages);
      }
    }
  }
}
