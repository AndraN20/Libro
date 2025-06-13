import 'dart:io';
import 'package:book_app/features/books/presentation/viewmodels/book_provider.dart';
import 'package:book_app/features/reader/presentation/widgets/epub_reader_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/features/books/domain/entities/book.dart';
import 'package:path_provider/path_provider.dart';

class BookDetailsScreen extends ConsumerStatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cover = widget.book.decodedCover;
    final downloadService = ref.read(bookDownloadServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    cover != null
                        ? Image.memory(
                          cover,
                          width: 150,
                          height: 220,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          width: 150,
                          height: 220,
                          color: Colors.grey[300],
                          child: const Icon(Icons.book, size: 40),
                        ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.book.author,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() => isLoading = true);

                final dir = await getApplicationDocumentsDirectory();
                final isUserAddedBook = widget.book.userId != null;
                final fileName =
                    isUserAddedBook
                        ? "${widget.book.id}.epub"
                        : "${widget.book.title}-${widget.book.author}"
                                .replaceAll(' ', '-') +
                            '.epub';

                final localPath = "${dir.path}/$fileName";
                File file = File(localPath);
                bool fileExists = await file.exists();

                if (!fileExists && !isUserAddedBook) {
                  final downloadedPath = await downloadService
                      .downloadBookFromUrl(widget.book.id, fileName);
                  if (downloadedPath != null) {
                    fileExists = true;
                    file = File(downloadedPath);
                  }
                }

                if (!fileExists) {
                  setState(() => isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cartea nu este salvată local."),
                    ),
                  );
                  return;
                }

                if (!context.mounted) return;
                setState(() => isLoading = false);

                // În loc de EpubReaderPageView, deschidem WebView-ul:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EpubReaderWebView(
                          epubFilePath: file.path,
                          initialCfi:
                              "", // sau salvezi undeva ultimul CFI și îl trimiți aici
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5F5BD1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text("Start Reading"),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.book.description ?? 'No description available.',
                style: const TextStyle(fontSize: 14, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reviews',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Don't make the mistake in thinking this is a fast-paced murder mystery... (sample)",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
