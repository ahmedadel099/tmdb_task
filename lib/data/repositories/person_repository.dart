// lib/data/repositories/person_repository.dart

import 'package:dio/dio.dart';
import '../models/person.dart';
import '../../core/api/api_client.dart';

class PersonRepository {
  final ApiClient _apiClient;

  PersonRepository(this._apiClient);

  Future<List<Person>> getPopularPeople(int page) async {
    try {
      final response = await _apiClient
          .get('/person/popular', queryParameters: {'page': page});
      final results = response.data['results'] as List;
      return results.map((json) => Person.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch popular people: $e');
    }
  }
}
