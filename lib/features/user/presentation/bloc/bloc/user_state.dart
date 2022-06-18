part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class Loading extends UserState {
  const Loading();

  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  const UserLoaded();

  @override
  List<Object> get props => [];
}

class Error extends UserState {
  const Error();

  @override
  List<Object> get props => [];
}
