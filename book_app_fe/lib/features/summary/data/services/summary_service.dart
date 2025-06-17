import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SummaryService {
  final Dio _dio;
  final String openAiApiKey;
  SummaryService()
    : _dio = Dio(),
      openAiApiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  List<String> _splitTextIntoChunks(String text, {int maxChars = 14000}) {
    List<String> chunks = [];
    int start = 0;
    while (start < text.length) {
      int end = start + maxChars;
      if (end > text.length) end = text.length;
      chunks.add(text.substring(start, end));
      start = end;
    }
    return chunks;
  }

  String cleanBookText(String text) {
    // 1. Elimină eventual disclaimer Project Gutenberg și copyright
    text = text.replaceAll(
      RegExp(
        r'(\*\*\* START OF (THIS|THE) PROJECT GUTENBERG.*?\*\*\*|'
        r'PROJECT GUTENBERG LICENSE.*?END OF THE PROJECT GUTENBERG LICENSE)',
        caseSensitive: false,
        dotAll: true,
      ),
      '',
    );

    // 2. Elimină eventual header de început/generic (ex: "---", "CHAPTER", "***")
    text = text.replaceAll(
      RegExp(
        r'^(?:\-{2,}|={2,}|~{2,}|\*{2,}|CHAPTER [IVXLCDM\d]+|TABLE OF CONTENTS|[A-Z ]{8,}|INTRODUCTION)\s*$',
        multiLine: true,
      ),
      '',
    );

    // 3. Elimină nota de copyright și surse la final, sau notele de subsol lungi
    text = text.replaceAll(
      RegExp(
        r'(End of (the|this) Project Gutenberg.*$|NOTES?[\s\S]+?$)',
        caseSensitive: false,
        dotAll: true,
      ),
      '',
    );

    // 4. Scoate multiple linii goale consecutive și spații extra
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    text = text.replaceAll(RegExp(r'[ \t]{2,}'), ' ');

    // 5. Elimină liniile foarte scurte, suspecte de a fi doar titluri/headers
    text = text.replaceAllMapped(
      RegExp(r'^(.*)$', multiLine: true),
      (match) => match.group(1)!.trim().length < 4 ? '' : match.group(1)!,
    );

    // 6. Elimină spații la început/sfârșit
    text = text.trim();

    return text;
  }

  Future<String> _summarizeChunk(String chunk, {int maxTokens = 2000}) async {
    try {
      final response = await _dio.post(
        "https://api.openai.com/v1/chat/completions",
        options: Options(
          headers: {
            'Authorization': 'Bearer $openAiApiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "Summarize the following text keeping it concise and clear, but minding the context. Exclude everything that comes before the start of the book and also exclude notes, headers and stylizations. Focus on the main ideas and key points of the story from the book. Also do not include the introduction of Project Gutenberg or anything else.",
            },
            {"role": "user", "content": chunk},
          ],
          "max_tokens": maxTokens,
          "temperature": 0.4,
        },
      );
      developer.log('Received chunk summary from OpenAI');
      return response.data['choices'][0]['message']['content'];
    } catch (e) {
      developer.log('Error calling OpenAI API: $e');
      return 'Error generating summary: $e';
    }
  }

  Future<List<T>> runConcurrent<T>(
    List<Future<T> Function()> tasks, {
    int maxConcurrent = 2,
  }) async {
    final results = List<T?>.filled(tasks.length, null);
    int nextTask = 0;

    Future<void> runTask(int i) async {
      while (true) {
        int taskIndex;
        if (nextTask >= tasks.length) return;
        taskIndex = nextTask++;
        results[taskIndex] = await tasks[taskIndex]();
      }
    }

    final runners = List.generate(maxConcurrent, (_) => runTask(0));
    await Future.wait(runners);
    return results.cast<T>();
  }

  Future<String> summarizeText(String text) async {
    if (text.isEmpty) {
      developer.log('Error: Empty text provided for summarization');
      return 'Error: No text available to summarize. Please try again after the book has fully loaded.';
    }

    // 0. Curăță textul înainte de chunking!
    text = cleanBookText(text);

    // 1. Split text in chunks
    final chunks = _splitTextIntoChunks(text);
    developer.log('Split text into ${chunks.length} chunks.');

    // 2. Summarize each chunk, max 2 in paralel
    final summaries = await runConcurrent(
      chunks.map((chunk) => () => _summarizeChunk(chunk)).toList(),
      maxConcurrent: 2,
    );

    // 3. If only 1 chunk, return directly
    if (summaries.length == 1) return summaries[0];

    // 4. Merge their summaries into a final summary
    final mergedSummary = await _summarizeChunk(
      summaries.join('\n\n'),
      maxTokens: 4000,
    );
    return mergedSummary;
  }
}
