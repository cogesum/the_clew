import 'package:bloc/bloc.dart';
import 'package:clew_app/features/events/data/repository/events_repository.dart';
import 'package:equatable/equatable.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventsRepository eventsRepository;
  EventBloc({required this.eventsRepository}) : super(EventInitial()) {
    on<EventEvent>((event, emit) async {
      if (event is OpenEventPage) {
        emit(Loading());
        try {
          final List events = await eventsRepository.getEventsData();
          emit(DataLoaded(events: events));
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      }
    });
  }
}
