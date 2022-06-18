part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {
  @override
  List<Object> get props => [];
}

class Loading extends EventState {
  @override
  List<Object> get props => [];
}

class DataLoaded extends EventState {
  const DataLoaded({required this.events});
  final List events;

  @override
  List<Object> get props => [events];
}

class Error extends EventState {
  const Error({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}
