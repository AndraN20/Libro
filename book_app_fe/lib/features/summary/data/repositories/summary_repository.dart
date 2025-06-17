import 'package:book_app/features/summary/data/services/summary_service.dart';

class SummaryRepository {
  final SummaryService _service;

  SummaryRepository(this._service);

  Future<String> getSummary(String text) async {
    return await _service.summarizeText(text);
  }
}
