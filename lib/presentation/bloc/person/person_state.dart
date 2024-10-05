import 'package:equatable/equatable.dart';
import 'package:tmdb_task_app/data/models/person_image.dart';
import '../../../data/models/person.dart';
import '../../../data/models/person_details.dart';

// States
abstract class PersonState extends Equatable {
  @override
  List<Object> get props => [];
}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> persons;
  final bool hasReachedMax;

  PersonLoaded({required this.persons, required this.hasReachedMax});

  @override
  List<Object> get props => [persons, hasReachedMax];
}

class PersonDetailsLoading extends PersonState {}

class PersonDetailsLoaded extends PersonState {
  final PersonDetails personDetails;
  final List<PersonImage> images;

  PersonDetailsLoaded({required this.personDetails, required this.images});

  @override
  List<Object> get props => [personDetails, images];
}

class PersonOffline extends PersonState {
  final List<Person> cachedPersons;

  PersonOffline({required this.cachedPersons});

  @override
  List<Object> get props => [cachedPersons];
}

class PersonError extends PersonState {
  final String message;

  PersonError({required this.message});

  @override
  List<Object> get props => [message];
}
