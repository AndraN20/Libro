import 'dart:io';
import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/books/presentation/viewmodels/book_provider.dart';
import 'package:book_app/features/progress/domain/models/progress.dart';
import 'package:book_app/features/progress/presentation/viewmodels/reader_progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class BookDetailsScreen extends ConsumerStatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  bool isLoading = false;
  Progress? progress;
  bool isLoadingProgress = true;
  String get initialCfi => progress?.epubCfi ?? "";

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final repo = ref.read(progressRepositoryProvider);
    final prog = await repo.loadProgress(widget.book.id);
    setState(() {
      progress = prog;
      isLoadingProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cover = widget.book.decodedCover;
    final downloadService = ref.read(bookDownloadServiceProvider);

    final isInProgress =
        progress != null && progress?.epubCfi.isNotEmpty == true;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background: Cover image blur + gradient overlay
          if (cover != null)
            Positioned.fill(
              child: Stack(
                children: [
                  // Cover image as background, blurred and faded
                  Positioned.fill(
                    child: Image.memory(cover, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(color: Colors.white.withOpacity(0.60)),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.white,
                            Colors.white,
                          ],
                          stops: [0.0, 0.65, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            // fallback dacă nu există coperta
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFE6E2F3), Colors.white],
                  ),
                ),
              ),
            ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // Săgeata de back cu padding și culoare
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                        size: 26,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        cover != null
                            ? Image.memory(
                              cover,
                              width: 180,
                              height: 260,
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
                const SizedBox(height: 25),
                Text(
                  widget.book.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPurple,
                  ),
                ),
                Text(
                  widget.book.author,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed:
                      isLoadingProgress
                          ? null
                          : () async {
                            setState(() => isLoading = true);

                            final dir =
                                await getApplicationDocumentsDirectory();
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
                                  .downloadBookFromUrl(
                                    widget.book.id,
                                    fileName,
                                  );
                              if (downloadedPath != null) {
                                fileExists = true;
                                file = File(downloadedPath);
                              }
                            }

                            if (!fileExists) {
                              setState(() => isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Cartea nu este salvată local.",
                                  ),
                                ),
                              );
                              return;
                            }

                            if (!context.mounted) return;
                            setState(() => isLoading = false);

                            final result = await context.push(
                              '/epub-reader',
                              extra: {
                                'filePath': file.path,
                                'initialCfi': initialCfi,
                                'bookId': widget.book.id,
                                'hasProgress': progress != null,
                              },
                            );

                            if (result == true && mounted) {
                              await _loadProgress();
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            isInProgress ? "Continue Reading" : "Start Reading",
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    widget.book.description ?? 'No description available.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.lightPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
