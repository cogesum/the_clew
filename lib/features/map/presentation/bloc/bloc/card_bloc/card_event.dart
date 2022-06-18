part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object> get props => [];
}

class CardOpen extends CardEvent {
  CardOpen({required this.index});
  int index;
}

class CardClose extends CardEvent {}
