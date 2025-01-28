
import 'package:assignment/presentation/bloc/todos/todos_event.dart';
import 'package:assignment/presentation/bloc/todos/todos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/TodoEntity.dart';
import '../../../domain/usecases/fetch_todos_usecase.dart';
import '../../../domain/usecases/update_todo_usecase.dart';


class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FetchTodosUseCase fetchTodosUseCase;
  final UpdateTodoUseCase updateTodoUseCase;

  // Keep a local list so we can patch changes
  List<TodoEntity> _allTodos = [];

  TodoBloc({
    required this.fetchTodosUseCase,
    required this.updateTodoUseCase,
  }) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<UpdateTodoEvent>(_onUpdateTodo);
  }

  Future<void> _onLoadTodos(LoadTodosEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await fetchTodosUseCase.call(event.userId);
      _allTodos = todos;
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    emit(UpdatingTodo());
    try {
      final updated = await updateTodoUseCase.call(event.todoId, event.completed);
      // Update local list
      final index = _allTodos.indexWhere((t) => t.id == event.todoId);
      if (index != -1) {
        _allTodos[index] = updated;
      }
      // Emit success
      emit(TodoUpdated(updated));
      // Then perhaps re-emit the entire list
      emit(TodoLoaded(_allTodos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
