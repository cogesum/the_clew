import 'package:clew_app/core/ui/app_color.dart';
import 'package:clew_app/features/events/data/repository/events_repository.dart';
import 'package:clew_app/features/events/presentation/bloc/bloc/event_bloc.dart';
import 'package:clew_app/features/events/presentation/widgets/event_card.dart';
import 'package:clew_app/features/metrics/bloc/bloc/metrics_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "События города",
          style: TextStyle(
              color: AppColor.mainColor,
              fontSize: 20,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RepositoryProvider(
        create: (context) => EventsRepository(),
        child: BlocProvider(
          create: (context) => EventBloc(
            eventsRepository: RepositoryProvider.of<EventsRepository>(context),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            child: const ListEvents(),
          ),
        ),
      ),
    );
  }
}

class ListEvents extends StatefulWidget {
  const ListEvents({Key? key}) : super(key: key);

  @override
  State<ListEvents> createState() => _ListEventsState();
}

class _ListEventsState extends State<ListEvents> {
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter = 0;

  @override
  void initState() {
    BlocProvider.of<EventBloc>(context).add(OpenEventPage());
    BlocProvider.of<MetricsBloc>(context)
        .add(MetricsOpenMap(openEventsPageCounter: 1, openMapCounter: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is DataLoaded) {
          return ListView.builder(
            itemCount: state.events.length,
            itemBuilder: ((context, index) {
              return EventCard(
                imgUrl: state.events[index]['imgUrl'],
                title: state.events[index]['title'],
                date: state.events[index]['date'],
                time: state.events[index]['time'],
                desciption: state.events[index]['description'],
                spendPoints: state.events[index]['spendPoints'],
                index: index,
              );
            }),
          );
        } else if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Error) {
          return const Center(
            child: Text("Проверьте подключение к сети"),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
