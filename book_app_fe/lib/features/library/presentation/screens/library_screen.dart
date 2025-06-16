import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/books/presentation/viewmodels/book_provider.dart';
import 'package:book_app/features/books/presentation/widgets/book_carousel.dart';
import 'package:book_app/features/books/presentation/widgets/book_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:book_app/features/books/presentation/screens/book_details_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool isLoading = false;

  Future<void> _handleAddBook() async {
    final uploadService = ref.watch(bookUploadServiceProvider);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.single.path == null) return;

    setState(() => isLoading = true);

    try {
      final pdfPath = result.files.single.path!;
      final epubResult = await uploadService.convertPdfAndSaveLocally(pdfPath);

      if (epubResult == null || !mounted) return;

      final book = await uploadService.fetchBookById(epubResult.bookId);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Eroare la procesarea fișierului: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAddedBooksAsync = ref.watch(userAddedBookListViewModelProvider);
    final generalLibraryBooksAsync = ref.watch(booksProvider);
    final startedBooksAsync = ref.watch(startedBooksProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        title: const Padding(
          padding: EdgeInsets.only(top: 20, left: 40, right: 40), // top moderat
          child: Text(
            "My Library",
            style: TextStyle(
              color: AppColors.darkPurple,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 40, top: 20),
            child: IconButton(
              onPressed: isLoading ? null : _handleAddBook,
              icon: SvgPicture.asset(
                'assets/icons/plus_circle.svg',
                height: 24,
                width: 24,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    startedBooksAsync.when(
                      data: (startedBooks) {
                        if (startedBooks.length >= 3) {
                          return StartedBooksCarousel(
                            startedBooks: startedBooks,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (e, st) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Added Books",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    userAddedBooksAsync.when(
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text("Error loading user books: $e"),
                      data:
                          (books) =>
                              books.isEmpty
                                  ? const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text("No added books yet."),
                                  )
                                  : BookList(books: books),
                    ),
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "From Our Library",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    generalLibraryBooksAsync.when(
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text("Error loading general books: $e"),
                      data:
                          (books) =>
                              books.isEmpty
                                  ? const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text("No general books available."),
                                  )
                                  : BookList(books: books),
                    ),
                  ],
                ),
              ),
    );
  }
}
