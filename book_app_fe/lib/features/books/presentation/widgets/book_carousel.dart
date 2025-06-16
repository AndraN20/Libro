// lib/features/books/presentation/widgets/book_carousel.dart

import 'package:book_app/features/books/domain/models/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartedBooksCarousel extends StatefulWidget {
  final List<Book> startedBooks;
  const StartedBooksCarousel({super.key, required this.startedBooks});

  @override
  State<StartedBooksCarousel> createState() => _StartedBooksCarouselState();
}

class _StartedBooksCarouselState extends State<StartedBooksCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    final initial = (widget.startedBooks.length / 2).floor();
    _controller = PageController(initialPage: initial, viewportFraction: 1 / 3);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.startedBooks.length < 3) return const SizedBox.shrink();

    final coverWidth = MediaQuery.of(context).size.width / 3.15;
    final coverHeight = coverWidth * 1.40;

    return SizedBox(
      height: coverHeight + 64,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double currentPage =
              _controller.hasClients
                  ? _controller.page ?? _controller.initialPage.toDouble()
                  : _controller.initialPage.toDouble();

          return PageView.builder(
            controller: _controller,
            itemCount: widget.startedBooks.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final diff = currentPage - index;
              final scale = (1 - (diff.abs() * 0.17)).clamp(0.84, 1.0);
              final isActive = currentPage.round() == index;
              final translateY = isActive ? 0.0 : 12.0 + (diff.abs() * 4);

              final book = widget.startedBooks[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Transform.scale(
                  scale: scale,
                  child: Transform.translate(
                    offset: Offset(0, translateY),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push('/book-details', extra: book);
                          },
                          child: Material(
                            elevation: isActive ? 13 : 2,
                            borderRadius: BorderRadius.circular(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
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
                        const SizedBox(height: 8),
                        SizedBox(
                          width: coverWidth,
                          height: 32,
                          child: Text(
                            book.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  isActive
                                      ? const Color(0xFF262675)
                                      : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: isActive ? 12 : 11.5,
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
                            style: TextStyle(
                              color:
                                  isActive
                                      ? const Color(0xFF262675)
                                      : Colors.grey[600],
                              fontSize: isActive ? 11 : 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
