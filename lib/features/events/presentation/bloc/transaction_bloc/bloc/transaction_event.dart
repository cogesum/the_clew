part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class PressButtonEvent extends TransactionEvent {
  int spendPoints;
  int index;
  PressButtonEvent(this.spendPoints, this.index);
}

class PressBuyTicketEvent extends TransactionEvent {
  int index;
  PressBuyTicketEvent(this.index);
}
