import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/config/dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.dio;
});
