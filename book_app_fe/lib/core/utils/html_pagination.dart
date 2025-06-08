import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

List<String> paginateByParagraphsOnly(String html, {int maxChars = 1000}) {
  final document = html_parser.parse(html);
  final body = document.body;
  if (body == null) return [];

  List<String> pages = [];
  List<Node> currentPageNodes = [];
  int currentLength = 0;

  void flushPage() {
    if (currentPageNodes.isEmpty) return;
    final pageHtml =
        currentPageNodes
            .map((n) => n is Element ? n.outerHtml : (n.text ?? ''))
            .join();
    pages.add(pageHtml);
    currentPageNodes.clear();
    currentLength = 0;
  }

  for (final node in body.nodes) {
    final text = node.text?.trim() ?? '';
    final tag = node is Element ? node.localName?.toLowerCase() : null;
    final length = text.length;

    // Dacă e paragraf și prea lung → se împarte în <p> blocuri
    if (tag == 'p' && length > maxChars) {
      final chunks = _splitText(text, maxChars);
      for (var chunk in chunks) {
        final pTag = '<p>${chunk.trim()}</p>';

        // dacă nu încape pagina curentă
        if (currentLength + chunk.length > maxChars) {
          flushPage();
        }

        currentPageNodes.add(html_parser.parseFragment(pTag).nodes.first);
        currentLength += chunk.length;
      }
      continue;
    }

    // Alte elemente: nu se taie, doar se mută pe pagină nouă dacă nu încape
    if (length > maxChars || currentLength + length > maxChars) {
      flushPage();
    }

    currentPageNodes.add(node);
    currentLength += length;
  }

  flushPage();
  return pages;
}

List<String> _splitText(String text, int chunkSize) {
  List<String> chunks = [];
  int start = 0;
  while (start < text.length) {
    int end =
        (start + chunkSize < text.length) ? start + chunkSize : text.length;
    int lastSpace = text.lastIndexOf(' ', end);
    if (lastSpace <= start) lastSpace = end;
    chunks.add(text.substring(start, lastSpace));
    start = lastSpace + 1;
  }
  return chunks;
}
