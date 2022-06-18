part of 'metrics_bloc.dart';

abstract class MetricsEvent extends Equatable {
  const MetricsEvent();

  @override
  List<Object> get props => [];
}

class MetricsOpenMap extends MetricsEvent {
  int openMapCounter;
  int openEventsPageCounter;

  MetricsOpenMap({
    required this.openEventsPageCounter,
    required this.openMapCounter,
  });
}

class MetricsOpenEventsPage extends MetricsEvent {
  int openMapCounter;
  int openEventsPageCounter;

  MetricsOpenEventsPage({
    required this.openEventsPageCounter,
    required this.openMapCounter,
  });
}
