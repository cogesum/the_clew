import 'package:bloc/bloc.dart';
import 'package:clew_app/features/events/data/repository/events_repository.dart';
import 'package:clew_app/features/map/data/repository/get_positions.dart';
import 'package:equatable/equatable.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final MapRepositories mapRepository;
  final EventsRepository eventsRepository;
  CardBloc({
    required this.mapRepository,
    required this.eventsRepository,
  }) : super(CardInitial()) {
    on<CardEvent>((event, emit) async {
      if (event is CardClose) {
        emit(CardCloseState(false));
      }

      if (event is CardOpen) {
        emit(Loading());

        try {
          final List locations = await mapRepository.getLocationData();
          final List events = await eventsRepository.getEventsData();

          locations.addAll(events);

          Map<String, dynamic> location = locations[event.index];

          emit(CardOpenState(
            location,
            isSelected: true,
          ));
        } catch (e) {
          emit(Error(e.toString()));
        }
      }
    });
  }
}
