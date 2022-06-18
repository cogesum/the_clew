part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class Loading extends TransactionState {}

class TransactionSuccessState extends TransactionState {}

class TransactionErrorState extends TransactionState {
  TransactionErrorState({required this.error});
  final String error;
}
