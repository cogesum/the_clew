import 'package:bloc/bloc.dart';
import 'package:clew_app/features/events/data/repository/events_repository.dart';
import 'package:clew_app/features/map/data/repository/get_positions.dart';
import 'package:equatable/equatable.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepositories mapRepository;
  final EventsRepository eventsRepository;
  MapBloc({
    required this.mapRepository,
    required this.eventsRepository,
  }) : super(MapInitial()) {
    on<MapEvent>((event, emit) async {
      if (event is MapOpenEvent) {
        emit(MapLoadingState());
        try {
          final List locations = await mapRepository.getLocationData();
          final List events = await eventsRepository.getEventsData();

          locations.addAll(events);

          emit(MapLoadedState(locations));
        } catch (e) {
          emit(MapErrorState(e.toString()));
        }
      }
    });
  }
}
