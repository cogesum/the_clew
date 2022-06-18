import 'package:clew_app/core/ui/app_color.dart';
import 'package:clew_app/features/events/data/repository/events_repository.dart';
import 'package:clew_app/features/events/presentation/pages/specific_event_page.dart';
import 'package:clew_app/features/map/data/repository/get_current_position.dart';
import 'package:clew_app/features/map/data/repository/get_positions.dart';
import 'package:clew_app/features/map/presentation/bloc/bloc/card_bloc/card_bloc.dart';
import 'package:clew_app/features/map/presentation/bloc/bloc/map_bloc.dart';
import 'package:clew_app/features/map/presentation/widgets/my_location_widget.dart';
import 'package:clew_app/features/metrics/bloc/bloc/metrics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';

const MARKER_SIZE_EXPANDED = 55.0;
const MARKER_SIZE_SHRINKED = 38.0;

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => EventsRepository(),
        child: RepositoryProvider(
          create: (context) => MapRepositories(),
          child: BlocProvider(
            create: (context) => MapBloc(
              mapRepository: RepositoryProvider.of<MapRepositories>(context),
              eventsRepository:
                  RepositoryProvider.of<EventsRepository>(context),
            ),
            child: Container(
              child: MapWidget(),
            ),
          ),
        ),
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  int _selectedIndex = 0;

  @override
  void initState() {
    BlocProvider.of<MapBloc>(context).add(MapOpenEvent());
    BlocProvider.of<MetricsBloc>(context)
        .add(MetricsOpenMap(openEventsPageCounter: 0, openMapCounter: 1));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is MapLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is MapLoadedState) {
          final _markerLocations = _buildLocationMarkers(state.locations);

          return Scaffold(
            body: Stack(children: [
              FutureBuilder(
                  future: getCurrentPosition(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FlutterMap(
                        options: MapOptions(
                          center: latLng.LatLng(
                            55.798000,
                            49.105000,
                          ),
                          zoom: 13.0,
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                                "https://api.mapbox.com/styles/v1/cogesum/cl2ra9klw002315l2wgon46pw/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY29nZXN1bSIsImEiOiJjbDJyYTFxcHkwOWYwM2lydHVoam9xcnRzIn0.m9sh8OR8VQ4TRBgmbuIwKA",
                            additionalOptions: {
                              "accessToken":
                                  "pk.eyJ1IjoiY29nZXN1bSIsImEiOiJjbDJyYTFxcHkwOWYwM2lydHVoam9xcnRzIn0.m9sh8OR8VQ4TRBgmbuIwKA",
                              "id": "mapbox.mapbox-streets-v8",
                            },
                            attributionBuilder: (_) {
                              return const Text("© The Clew");
                            },
                          ),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: MARKER_SIZE_EXPANDED,
                                height: MARKER_SIZE_EXPANDED,
                                point: latLng.LatLng(
                                  (snapshot.data as Position).latitude,
                                  (snapshot.data as Position).longitude,
                                ),
                                builder: (_) => const MyLocationWidget(),
                              ),
                            ],
                          ),
                          MarkerLayerOptions(
                            markers: _markerLocations,
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
              BlocBuilder<CardBloc, CardState>(
                builder: (context, state) {
                  if (state is CardOpenState) {
                    return Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Card(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.4),
                                                BlendMode.darken),
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                state.location['imgUrl']),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Chip(
                                                  backgroundColor:
                                                      AppColor.mainColor,
                                                  label: Text(
                                                      state.location['date'] ??
                                                          state.location[
                                                              'workTime'],
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                                Chip(
                                                  backgroundColor:
                                                      AppColor.mainColor,
                                                  label: Text(
                                                      state
                                                          .location['getPoints']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    state.location['title'],
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColor.mainColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          children: [
                                            Text(
                                              state.location['description'],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                left: 10,
                                child: Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SpecificEventPage(
                                              imgUrl: state.location['imgUrl'],
                                              title: state.location['title'],
                                              date: state.location['date'] ??
                                                  state.location['workTime'],
                                              time: state.location['time'],
                                              desciption:
                                                  state.location['description'],
                                              spendPoints:
                                                  state.location['spendPoints'],
                                              identify:
                                                  state.location['identify'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Узнать больше'),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          state.location['identify'] == 0
                                              ? Color.fromARGB(
                                                  255, 107, 180, 239)
                                              : Color.fromARGB(
                                                  255, 245, 137, 129),
                                        ),
                                      )),
                                ),
                              ),
                              Positioned(
                                top: -5,
                                right: -5,
                                child: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<CardBloc>(context)
                                        .add(CardClose());
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: AppColor.mainColor,
                                  ),
                                  iconSize: 30,
                                  splashRadius: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ]),
          );
        } else {
          return Container();
        }
      },
    );
  }

  List<Marker> _buildLocationMarkers(List locations) {
    final List<Marker> _markersList = [];
    for (int i = 0; i < locations.length; i++) {
      final mapItem = locations[i];
      _markersList.add(
        Marker(
          rotate: true,
          width: 50.0,
          height: 50.0,
          point: latLng.LatLng(mapItem['lat'], mapItem['lon']),
          builder: (_) {
            return BlocBuilder<CardBloc, CardState>(
              builder: (context, state) {
                if (state is CardCloseState) {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<CardBloc>(context)
                          .add(CardOpen(index: i));
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
                    child: _LocationMarker(
                        isSelected: state.isSelected,
                        identify: mapItem['identify']),
                  );
                } else if (state is CardOpenState) {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<CardBloc>(context).add(CardClose());
                      BlocProvider.of<CardBloc>(context)
                          .add(CardOpen(index: i));
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
                    child: _LocationMarker(
                        isSelected: _selectedIndex == i,
                        identify: mapItem['identify']),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<CardBloc>(context)
                          .add(CardOpen(index: i));
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
                    child: _LocationMarker(identify: mapItem['identify']),
                  );
                }
              },
            );
          },
        ),
      );
    }
    return _markersList;
  }

  // List<Marker> _buildEventsMarkers(List events) {
  //   final List<Marker> _markersList = [];
  //   for (int i = 0; i < events.length; i++) {
  //     final mapItem = events[i];
  //     _markersList.add(
  //       Marker(
  //         rotate: true,
  //         width: 50.0,
  //         height: 50.0,
  //         point: latLng.LatLng(mapItem['lat'], mapItem['lon']),
  //         builder: (_) {
  //           return BlocBuilder<CardBloc, CardState>(
  //             builder: (context, state) {
  //               if (state is CardCloseState) {
  //                 return GestureDetector(
  //                   onTap: () {
  //                     BlocProvider.of<CardBloc>(context)
  //                         .add(CardOpen(index: i));
  //                     setState(() {
  //                       _selectedIndex = i;
  //                     });
  //                   },
  //                   child: _LocationMarker(
  //                     isSelected: state.isSelected,
  //                   ),
  //                 );
  //               } else if (state is CardOpenEventState) {
  //                 return GestureDetector(
  //                   onTap: () {
  //                     BlocProvider.of<CardBloc>(context).add(CardClose());
  //                     BlocProvider.of<CardBloc>(context)
  //                         .add(CardOpen(index: i));
  //                     setState(() {
  //                       _selectedIndex = i;
  //                     });
  //                   },
  //                   child: _LocationMarker(isSelected: _selectedIndex == i),
  //                 );
  //               } else {
  //                 return GestureDetector(
  //                   onTap: () {
  //                     BlocProvider.of<CardBloc>(context)
  //                         .add(CardOpen(index: i));
  //                     setState(() {
  //                       _selectedIndex = i;
  //                     });
  //                   },
  //                   child: const _EventsMarker(isSelected: false),
  //                 );
  //               }
  //             },
  //           );
  //         },
  //       ),
  //     );
  //   }
  //   return _markersList;
  // }
}

class _LocationMarker extends StatelessWidget {
  _LocationMarker({Key? key, this.isSelected = false, required this.identify})
      : super(key: key);
  final bool isSelected;
  final int identify;

  @override
  Widget build(BuildContext context) {
    final double size =
        isSelected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED;
    return Center(
      child: AnimatedContainer(
        width: size,
        height: size,
        duration: const Duration(milliseconds: 200),
        child: Image.asset(
          identify == 0
              ? 'assets/images/blue_marker.png'
              : 'assets/images/red_marker.png',
        ),
      ),
    );
  }
}

// class _EventsMarker extends StatelessWidget {
//   const _EventsMarker({Key? key, this.isSelected = false}) : super(key: key);
//   final bool isSelected;

//   @override
//   Widget build(BuildContext context) {
//     final double size =
//         isSelected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED;
//     return Center(
//       child: AnimatedContainer(
//         width: size,
//         height: size,
//         duration: const Duration(milliseconds: 200),
//         child: Image.asset(
//           'assets/images/red_marker.png',
//         ),
//       ),
//     );
//   }
// }


