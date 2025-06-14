import 'package:book_app/features/progress/domain/models/progress.dart';
import 'package:dio/dio.dart';

class ProgressService {
  final Dio dio;

  ProgressService(this.dio);

  Future<Progress?> getProgress(int bookId) async {
    try {
      final response = await dio.get('/progress/$bookId');
      return Progress.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> saveProgress(int bookId, Progress progress) async {
    try {
      await dio.post('/progress/$bookId', data: progress.toJson());
    } on DioException catch (e) {
      throw Exception("Failed to save progress: ${e.response?.data}");
    }
  }
}
