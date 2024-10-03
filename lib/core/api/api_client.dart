import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options.baseUrl = 'https://api.themoviedb.org/3';
    final apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
    _dio.options.queryParameters = {'api_key': apiKey};  }

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
