// lib/data/models/person.dart

import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final int id;
  final String name;
  final String? profilePath;

  const Person({required this.id, required this.name, this.profilePath});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
    );
  }

  @override
  List<Object?> get props => [id, name, profilePath];
}
