part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class OpenEventPage extends EventEvent {}

class OpenSpecificEventPage extends EventEvent {}
