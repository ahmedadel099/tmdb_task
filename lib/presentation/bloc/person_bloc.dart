// lib/presentation/bloc/person_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/person.dart';
import '../../data/repositories/person_repository.dart';

// Events
abstract class PersonEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPersons extends PersonEvent {}

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

class PersonError extends PersonState {
  final String message;

  PersonError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;
  int _currentPage = 1;

  PersonBloc({required this.repository}) : super(PersonInitial()) {
    on<FetchPersons>(_onFetchPersons);
  }

  Future<void> _onFetchPersons(
      FetchPersons event, Emitter<PersonState> emit) async {
    if (state is PersonLoaded && (state as PersonLoaded).hasReachedMax) return;

    try {
      if (state is PersonInitial) {
        emit(PersonLoading());
        final persons = await repository.getPopularPeople(_currentPage);
        emit(PersonLoaded(persons: persons, hasReachedMax: false));
        _currentPage++;
      } else if (state is PersonLoaded) {
        final currentState = state as PersonLoaded;
        final persons = await repository.getPopularPeople(_currentPage);
        emit(persons.isEmpty
            ? PersonLoaded(persons: currentState.persons, hasReachedMax: true)
            : PersonLoaded(
                persons: currentState.persons + persons,
                hasReachedMax: false,
              ));
        _currentPage++;
      }
    } catch (e) {
      emit(PersonError(message: 'Failed to fetch persons: $e'));
    }
  }
}
