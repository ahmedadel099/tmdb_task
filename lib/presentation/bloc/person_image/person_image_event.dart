import 'package:equatable/equatable.dart';

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
