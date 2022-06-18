import 'package:clew_app/core/ui/app_color.dart';
import 'package:clew_app/features/events/data/repository/events_repository.dart';
import 'package:clew_app/features/events/presentation/pages/events.dart';
import 'package:clew_app/features/map/data/repository/get_positions.dart';
import 'package:clew_app/features/map/presentation/bloc/bloc/card_bloc/card_bloc.dart';
import 'package:clew_app/features/map/presentation/bloc/bloc/map_bloc.dart';
import 'package:clew_app/features/map/presentation/pages/map_page.dart';
import 'package:clew_app/features/metrics/bloc/bloc/metrics_bloc.dart';
import 'package:clew_app/features/metrics/data/metrics_repository.dart';
import 'package:clew_app/features/user/presentation/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  static const List<Widget> _widgetNavigation = <Widget>[
    EventPage(),
    MapPage(),
    UserPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => EventsRepository(),
        ),
        RepositoryProvider(
          create: (context) => MetricsRepository(),
        ),
        RepositoryProvider(
          create: (context) => MapRepositories(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => MapBloc(
                    mapRepository:
                        RepositoryProvider.of<MapRepositories>(context),
                    eventsRepository:
                        RepositoryProvider.of<EventsRepository>(context),
                  )),
          BlocProvider(
              create: (context) => CardBloc(
                    mapRepository:
                        RepositoryProvider.of<MapRepositories>(context),
                    eventsRepository:
                        RepositoryProvider.of<EventsRepository>(context),
                  )),
          BlocProvider(
              create: (context) => MetricsBloc(
                    metricsRepository:
                        RepositoryProvider.of<MetricsRepository>(context),
                  )),
        ],
        child: Scaffold(
          body: _widgetNavigation.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppColor.secondColor,
              elevation: 0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: "События",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: "Карта",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Аккаунт",
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppColor.mainColor,
              unselectedItemColor: Colors.white.withOpacity(0.6),
              onTap: _inItemTap),
        ),
      ),
    );
  }

  void _inItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
