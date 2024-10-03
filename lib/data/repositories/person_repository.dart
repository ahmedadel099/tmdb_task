// lib/data/repositories/person_repository.dart

import 'package:dio/dio.dart';
import '../models/person.dart';
import '../../core/api/api_client.dart';
import '../models/person_details.dart';
import '../models/person_image.dart';

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
    Future<PersonDetails> getPersonDetails(int personId) async {
    try {
      final response = await _apiClient.get('/person/$personId');
      return PersonDetails.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch person details: $e');
    }
  }
 
  Future<List<PersonImage>> getPersonImages(int personId) async {
    try {
      final response = await _apiClient.get('/person/$personId/images');
      final List<dynamic> profiles = response.data['profiles'];
      return profiles.map((profile) => PersonImage.fromJson(profile)).toList();
    } catch (error) {
      throw Exception('Failed to fetch person images: $error');
    }
  }
  
}
