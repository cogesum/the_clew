part of 'card_bloc.dart';

abstract class CardState extends Equatable {
  const CardState();

  @override
  List<Object> get props => [];
}

class CardInitial extends CardState {}

class Loading extends CardState {}

class CardOpenState extends CardState {
  CardOpenState(this.location, {required this.isSelected});
  Map<String, dynamic> location;
  bool isSelected = true;

  @override
  List<Object> get props => [isSelected, location];
}

class CardCloseState extends CardState {
  CardCloseState(this.isSelected);

  bool isSelected = false;

  @override
  List<Object> get props => [isSelected];
}

class Error extends CardState {
  Error(this.error);
  String error;

  @override
  List<Object> get props => [error];
}
