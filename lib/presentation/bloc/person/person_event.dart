import 'package:equatable/equatable.dart';

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
