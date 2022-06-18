import 'package:bloc/bloc.dart';
import 'package:clew_app/features/events/data/repository/transaction_repository.dart';
import 'package:clew_app/features/user/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final UserRepository userRepository;
  final TransactionRepository transactionRepository;
  TransactionBloc({
    required this.userRepository,
    required this.transactionRepository,
  }) : super(TransactionInitial()) {
    on<TransactionEvent>((event, emit) async {
      if (event is PressBuyTicketEvent) {
        emit(Loading());
        List<String> listOfEventId = [];
        List listOfUsersIdCurrentEvent = [];
        final List<String> eventId = await transactionRepository.getEventsId();
        final List<Map<String, dynamic>> eventIdTransaction =
            await transactionRepository.getTransactionInfo();
        final String userId = FirebaseAuth.instance.currentUser!.uid;
        eventIdTransaction
            .map(
              (event) => listOfEventId.add(event['eventId']),
            )
            .toList();

        for (int i = 0; i < eventIdTransaction.length; i++) {
          if (eventId[event.index] == listOfEventId[i]) {
            listOfUsersIdCurrentEvent.add(eventIdTransaction[i]['userId']);
          }
        }

        if (listOfEventId.contains(eventId[event.index]) &&
            listOfUsersIdCurrentEvent.contains(userId)) {
          emit(TransactionSuccessState());
        }
      } else if (event is PressButtonEvent) {
        EasyLoading.show(status: 'Ждем ответа...');
        emit(Loading());

        try {
          final userData = await userRepository.getInfoFromDB();
          final eventId = await transactionRepository.getEventsId();
          if (userData.data()!['points'] - event.spendPoints < 0) {
            EasyLoading.showError('Где деньги, Лебовски?');
          } else {
            emit(TransactionSuccessState());
            final firebaseAuth = FirebaseAuth.instance;
            await userRepository
                .setNewPoints(userData.data()!['points'] - event.spendPoints);
            await transactionRepository.addTransactionInfo(
                eventId[event.index],
                userData.data()!['points'] - event.spendPoints,
                userData.data()!['points'],
                event.spendPoints,
                firebaseAuth.currentUser!.uid,
                DateTime.now());
            EasyLoading.showSuccess('Успешно!');
          }
        } catch (e) {
          emit(TransactionErrorState(error: e.toString()));
          EasyLoading.showError('Попробуйте позже!');
        }
      }
    });
  }
}
