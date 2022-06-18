part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  SignUpRequested(this.username, this.email, this.password);
}

class GoogleSignInRequested extends AuthEvent {}

class SignOut extends AuthEvent {}
