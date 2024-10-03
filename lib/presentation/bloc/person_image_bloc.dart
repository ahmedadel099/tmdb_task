import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/person_image.dart';
import '../../data/repositories/person_repository.dart';

// Events
abstract class PersonImagesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPersonImages extends PersonImagesEvent {
  final int personId;

  FetchPersonImages(this.personId);

  @override
  List<Object> get props => [personId];
}

// States
abstract class PersonImagesState extends Equatable {
  @override
  List<Object> get props => [];
}

class PersonImagesInitial extends PersonImagesState {}

class PersonImagesLoading extends PersonImagesState {}

class PersonImagesLoaded extends PersonImagesState {
  final List<PersonImage> images;

  PersonImagesLoaded({required this.images});

  @override
  List<Object> get props => [images];
}

class PersonImagesError extends PersonImagesState {
  final String message;

  PersonImagesError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class PersonImagesBloc extends Bloc<PersonImagesEvent, PersonImagesState> {
  final PersonRepository repository;

  PersonImagesBloc({required this.repository}) : super(PersonImagesInitial()) {
    on<FetchPersonImages>(_onFetchPersonImages);
  }

  Future<void> _onFetchPersonImages(
      FetchPersonImages event, Emitter<PersonImagesState> emit) async {
    emit(PersonImagesLoading());
    try {
      final images = await repository.getPersonImages(event.personId);
      emit(PersonImagesLoaded(images: images));
    } catch (e) {
      emit(PersonImagesError(message: 'Failed to fetch person images: $e'));
    }
  }
}
