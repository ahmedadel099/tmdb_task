import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/network_info.dart';
import '../../../data/repositories/person_repository.dart';
import 'person_event.dart';
import 'person_state.dart';


// BLoC
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;
    final NetworkInfo? networkInfo;

  int _currentPage = 1;

  PersonBloc({required this.repository,  this.networkInfo})
      : super(PersonInitial()) {
    on<FetchPersons>(_onFetchPersons);
    on<FetchPersonDetails>(_onFetchPersonDetails);
    on<CheckConnectivity>(_onCheckConnectivity);
  }

  Future<void> _onFetchPersons(
      FetchPersons event, Emitter<PersonState> emit) async {
    if (state is PersonLoaded && (state as PersonLoaded).hasReachedMax) return;

    try {
      final isConnected = await networkInfo!.isConnected;
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
    print('CheckConnectivity triggered');
    final isConnected = await networkInfo!.isConnected;
    if (!isConnected) {
      final cachedPersons = repository.getCachedPeople();
      emit(PersonOffline(cachedPersons: cachedPersons));
      print('Emitting PersonOffline state');
    } else {
      add(FetchPersons());
    }
  }

}
