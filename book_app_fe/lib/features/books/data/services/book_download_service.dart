import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class BookDownloadService {
  final Dio _dio;

  BookDownloadService(this._dio);

  Future<String?> getSignedUrlById(int bookId) async {
    try {
      final response = await _dio.get('/books/$bookId/signed-url');
      return response.data['signed_url'];
    } catch (e) {
      print("Eroare la obținerea signed URL: $e");
      return null;
    }
  }

  Future<String?> downloadBook(String signedUrl, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/$fileName.epub";

      await _dio.download(signedUrl, path);
      return path;
    } catch (e) {
      print("Eroare la descărcare: $e");
      return null;
    }
  }

  Future<String?> downloadBookFromUrl(int bookId, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/$fileName";

      // ✅ Dacă deja există, returnează direct
      final file = File(path);
      if (await file.exists()) {
        print("Carte găsită local: $path");
        return path;
      }

      // 🔁 Dacă nu există, obține signed URL
      final signedUrl = await getSignedUrlById(bookId);
      if (signedUrl == null) {
        print(
          "Eroare: nu am putut obține signed URL pentru cartea cu ID: $bookId",
        );
        return null;
      }

      // 💾 Descarcă și salvează
      await _dio.download(signedUrl, path);
      print("Carte descărcată la: $path");
      return path;
    } catch (e, stack) {
      print("Eroare în downloadBookFromUrl: $e");
      print(stack);
      return null;
    }
  }
}
