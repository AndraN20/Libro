import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/books/presentation/viewmodels/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// importă providerul tău

class BookSlider extends ConsumerStatefulWidget {
  final List<Book> books;
  final void Function(Book)? onBookTap;
  final Widget Function(BuildContext, Book)? footerBuilder;

  const BookSlider({
    super.key,
    required this.books,
    this.onBookTap,
    this.footerBuilder,
  });

  @override
  ConsumerState<BookSlider> createState() => _BookSliderState();
}

class _BookSliderState extends ConsumerState<BookSlider> {
  late final PageController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0, viewportFraction: 0.7);
  }

  Future<void> _handleBookTap(Book book) async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(bookRepositoryProvider);
      final detailedBook = await repo.getBook(book.id);

      if (mounted) {
        setState(() => _isLoading = false);
        context.push('/book-details', extra: detailedBook);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Eroare la încărcarea cărții')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) return const SizedBox.shrink();

    final coverWidth = MediaQuery.of(context).size.width * 0.44 * 0.95;
    final coverHeight = coverWidth * 1.55;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: coverHeight + 64,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.books.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final book = widget.books[index];
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.onBookTap != null) {
                          widget.onBookTap!(book);
                        } else {
                          _handleBookTap(book);
                        }
                      },

                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              book.decodedCover != null
                                  ? Image.memory(
                                    book.decodedCover!,
                                    width: coverWidth,
                                    height: coverHeight,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(
                                    width: coverWidth,
                                    height: coverHeight,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.book, size: 36),
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.footerBuilder != null)
                      widget.footerBuilder!(context, book)
                    else ...[
                      SizedBox(
                        width: coverWidth,
                        height: 32,
                        child: Text(
                          book.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF262675),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      SizedBox(
                        width: coverWidth,
                        height: 15,
                        child: Text(
                          book.author,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
