import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserLoadedEvent>((event, emit) {
      // TODO: implement event handler
      emit(UserLoadedState(details: event.user));
    });
  }
}
