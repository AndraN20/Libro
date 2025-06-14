import 'dart:io';
import 'package:book_app/features/books/data/repositories/book_repository.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/books/data/models/book_dto.dart';

class BookUploadService {
  final Dio dio;
  final BookRepository bookRepository;

  BookUploadService({required this.dio, required this.bookRepository});

  Future<_EpubResult?> convertPdfAndSaveLocally(String pdfPath) async {
    final file = await MultipartFile.fromFile(
      pdfPath,
      filename: pdfPath.split(Platform.pathSeparator).last,
      contentType: MediaType('application', 'pdf'),
    );
    final formData = FormData.fromMap({'file': file});

    final response = await dio.post(
      '/books/convert',
      data: formData,
      options: Options(responseType: ResponseType.bytes),
    );

    final contentDisp = response.headers.map['content-disposition']?.first;
    final fileName = RegExp(
      r'filename="?([^"]+)"?',
    ).firstMatch(contentDisp ?? '')?.group(1);

    if (fileName == null) throw Exception("Filename missing from response.");

    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/$fileName";

    final fileOut = File(filePath);
    await fileOut.writeAsBytes(response.data);

    final bookId = int.parse(fileName.split('.').first);
    return _EpubResult(bookId: bookId, filePath: filePath);
  }

  Future<Book> fetchBookById(int bookId) async {
    final response = await dio.get('/books/$bookId');
    return BookDto.fromJson(response.data).toDomain();
  }
}

class _EpubResult {
  final int bookId;
  final String filePath;

  _EpubResult({required this.bookId, required this.filePath});
}
