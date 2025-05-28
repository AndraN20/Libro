import 'package:book_app/config/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'secure_storage.dart';

class DioClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: baseApiUrl,
            connectTimeout: apiConnectTimeout,
            receiveTimeout: apiReceiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            logPrint: (obj) => debugPrint(obj.toString()),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await SecureStorage.readToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await SecureStorage.readToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
            onError: (DioException e, handler) async {
              if (e.response?.statusCode == 401) {
                await SecureStorage.deleteToken();
                navigatorKey.currentState?.pushReplacementNamed(
                  RouteNames.login,
                );
              }
              return handler.next(e);
            },
          ),
        );
}
