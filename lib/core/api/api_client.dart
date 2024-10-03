// lib/core/api/api_client.dart

import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options.baseUrl = 'https://api.themoviedb.org/3';
    _dio.options.queryParameters = {'api_key': '3113eca177ad9d625cfea6e284208461'};
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }
}
