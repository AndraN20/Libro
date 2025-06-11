import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/features/books/domain/entities/book.dart';
import 'package:book_app/features/books/presentation/screens/book_details_screen.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool isLoading = false;

  Future<void> _handleAddBook() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.single.path == null) return;

    setState(() => isLoading = true);

    try {
      final book = await BookUploadService().convertUploadAndGetBook(
        result.files.single.path!,
      );

      if (book != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
        );
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Library"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: isLoading ? null : _handleAddBook,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : const Center(child: Text("No books yet.")),
    );
  }
}
