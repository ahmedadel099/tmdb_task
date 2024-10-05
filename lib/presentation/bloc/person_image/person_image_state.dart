import 'package:equatable/equatable.dart';
import '../../../data/models/person_image.dart';

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
