// lib/presentation/bloc/person_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdb_task_app/data/models/person_image.dart';
import '../../core/network/network_info.dart';
import '../../data/models/person.dart';
import '../../data/models/person_details.dart';
import '../../data/repositories/person_repository.dart';

// Events
abstract class PersonEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckConnectivity extends PersonEvent {}


class FetchPersons extends PersonEvent {}

class FetchPersonDetails extends PersonEvent {
  final int personId;

  FetchPersonDetails(this.personId);

  @override
  List<Object> get props => [personId];
}



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

// BLoC
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;
    final NetworkInfo networkInfo;

  int _currentPage = 1;

  PersonBloc({required this.repository, required this.networkInfo})
      : super(PersonInitial()) {
    on<FetchPersons>(_onFetchPersons);
    on<FetchPersonDetails>(_onFetchPersonDetails);
    on<CheckConnectivity>(_onCheckConnectivity);
  }

  Future<void> _onFetchPersons(
      FetchPersons event, Emitter<PersonState> emit) async {
    if (state is PersonLoaded && (state as PersonLoaded).hasReachedMax) return;

    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        final cachedPersons = repository.getCachedPeople();
        emit(PersonOffline(cachedPersons: cachedPersons));
        return;
      }

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
   Future<void> _onFetchPersonDetails(
      FetchPersonDetails event, Emitter<PersonState> emit) async {
    emit(PersonDetailsLoading());
    try {
      final personDetails = await repository.getPersonDetails(event.personId);
      final  images = await repository.getPersonImages(event.personId);
      emit(PersonDetailsLoaded(personDetails: personDetails, images: images ));
    } catch (e) {
      emit(PersonError(message: 'Failed to fetch person details: $e'));
    }
  }

  Future<void> _onCheckConnectivity(
      CheckConnectivity event, Emitter<PersonState> emit) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      final cachedPersons = repository.getCachedPeople();
      emit(PersonOffline(cachedPersons: cachedPersons));
    } else {
      add(FetchPersons());
    }
  }

}
