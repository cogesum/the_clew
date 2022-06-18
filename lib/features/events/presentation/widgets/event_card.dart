import 'package:clew_app/features/events/data/repository/transaction_repository.dart';
import 'package:clew_app/features/events/presentation/bloc/transaction_bloc/bloc/transaction_bloc.dart';
import 'package:clew_app/features/events/presentation/pages/specific_event_page.dart';
import 'package:clew_app/features/user/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCard extends StatelessWidget {
  String imgUrl;
  String title;
  String time;
  String date;
  String desciption;
  int spendPoints;
  int index;
  EventCard(
      {required this.imgUrl,
      required this.title,
      required this.time,
      required this.date,
      required this.desciption,
      required this.spendPoints,
      required this.index,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TransactionRepository(),
      child: RepositoryProvider(
        create: (context) => UserRepository(),
        child: BlocProvider(
          create: (context) => TransactionBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            transactionRepository:
                RepositoryProvider.of<TransactionRepository>(context),
          ),
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  BlocProvider.of<TransactionBloc>(context)
                      .add(PressBuyTicketEvent(index));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpecificEventPage(
                        imgUrl: imgUrl,
                        title: title,
                        time: time,
                        date: date,
                        desciption: desciption,
                        spendPoints: spendPoints,
                        index: index,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Card(
                      shadowColor: Colors.black,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    width: double.infinity,
                                    height: 150,
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                    )),
                                const Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Icon(
                                      Icons.favorite_outline,
                                      color: Colors.white,
                                    )),
                                Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Text(
                                      date,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: Container(
                                    width: 60,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      time,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                title,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
