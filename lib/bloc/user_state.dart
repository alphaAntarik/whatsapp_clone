part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoadedState extends UserState {
  final String details;
  UserLoadedState({required this.details});
}
