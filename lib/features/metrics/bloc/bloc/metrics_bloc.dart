import 'package:bloc/bloc.dart';
import 'package:clew_app/features/metrics/data/metrics_repository.dart';
import 'package:equatable/equatable.dart';

part 'metrics_event.dart';
part 'metrics_state.dart';

class MetricsBloc extends Bloc<MetricsEvent, MetricsState> {
  final MetricsRepository metricsRepository;
  MetricsBloc({required this.metricsRepository}) : super(MetricsInitial()) {
    on<MetricsEvent>((event, emit) async {
      if (event is MetricsOpenMap) {
        try {
          final metricsData = await metricsRepository.getMetricsInfo();
          int mapCounter = metricsData['open_map'] + event.openMapCounter;
          await metricsRepository.setMetricsInfo(
            metricsData['open_events_page'] + event.openEventsPageCounter,
            mapCounter,
          );
          print(mapCounter);
        } catch (e) {
          print(e);
        }
      }

      if (event is MetricsOpenEventsPage) {
        try {
          final metricsData = await metricsRepository.getMetricsInfo();
          await metricsRepository.setMetricsInfo(
            metricsData['open_events_page'] + event.openEventsPageCounter,
            metricsData['open_map'] + event.openMapCounter,
          );
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
