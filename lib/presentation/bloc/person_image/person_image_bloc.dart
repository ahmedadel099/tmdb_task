import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/person_repository.dart';
import 'person_image_event.dart';
import 'person_image_state.dart';

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
