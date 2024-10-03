import 'package:hive/hive.dart';
import '../models/person.dart';
import '../../core/api/api_client.dart';
import '../models/person_details.dart';
import '../models/person_image.dart';

class PersonRepository {
  final ApiClient _apiClient;
  final Box<Person> _personBox;

  PersonRepository(this._apiClient, this._personBox);



  Future<List<Person>> getPopularPeople(int page) async {
    try {
      final response = await _apiClient
          .get('/person/popular', queryParameters: {'page': page});
      final results = response.data['results'] as List;
      final persons = results.map((json) => Person.fromJson(json)).toList();

      // Save to Hive
      await _personBox.clear();
      await _personBox.addAll(persons);

      return persons;
    } catch (e) {
      // If there's an error, try to load from Hive
      final cachedPersons = _personBox.values.toList();
      if (cachedPersons.isNotEmpty) {
        return cachedPersons;
      }
      throw Exception('Failed to fetch popular people: $e');
    }
  }

  List<Person> getCachedPeople() {
    return _personBox.values.toList();
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
