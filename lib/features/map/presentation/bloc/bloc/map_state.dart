part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

class MapLoadingState extends MapState {
  @override
  List<Object> get props => [];
}

class MapLoadedState extends MapState {
  List locations;

  MapLoadedState(this.locations);

  @override
  List<Object> get props => [];
}

class MapErrorState extends MapState {
  final String error;

  MapErrorState(this.error);

  @override
  List<Object> get props => [error];
}
