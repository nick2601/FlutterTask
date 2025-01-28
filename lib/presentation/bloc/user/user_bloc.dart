import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/UserEntity.dart';
import '../../../domain/usecases/fetch_users_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FetchUsersUseCase fetchUsersUseCase;

  List<UserEntity> _allUsers = [];

  UserBloc({required this.fetchUsersUseCase}) : super(UserInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<SortUsersEvent>(_onSortUsers);
    on<FilterUsersEvent>(_onFilterUsers);
  }

  Future<void> _onLoadUsers(
      LoadUsersEvent event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final users = await fetchUsersUseCase.call();
      _allUsers = users;
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onSortUsers(
      SortUsersEvent event,
      Emitter<UserState> emit,
      ) {
    if (state is UserLoaded) {
      final current = (state as UserLoaded).users;
      final sorted = [...current]..sort((a, b) => a.name.compareTo(b.name));
      _allUsers = sorted;
      emit(UserLoaded(sorted));
    }
  }

  void _onFilterUsers(
      FilterUsersEvent event,
      Emitter<UserState> emit,
      ) {
    if (state is UserLoaded) {
      final filtered = _allUsers.where((user) {
        return user.username.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      emit(UserLoaded(filtered));
    }
  }
}
