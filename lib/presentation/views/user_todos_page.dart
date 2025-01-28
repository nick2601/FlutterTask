import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../../domain/entities/TodoEntity.dart';
import '../bloc/todos/todos_bloc.dart';
import '../bloc/todos/todos_event.dart';
import '../bloc/todos/todos_state.dart';
import '../utils/helper.dart';


class UserTodosPage extends StatefulWidget {
  final int userId;
  const UserTodosPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserTodosPage> createState() => _UserTodosPageState();
}

class _UserTodosPageState extends State<UserTodosPage> {
  late TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    // Obtain the bloc from GetIt and load this user's todos
    _todoBloc = getIt<TodoBloc>()..add(LoadTodosEvent(widget.userId));
  }

  @override
  void dispose() {
    _todoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the bloc to the subtree
    return BlocProvider<TodoBloc>(
      create: (_) => _todoBloc,
      child: Container(
        // A vertical gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<TodoBloc, TodoState>(
            listener: (context, state) {
              if (state is TodoError) {
                // Show an error snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              } else if (state is TodoUpdated) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Todo #${state.updated.id} updated!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is TodoLoading || state is UpdatingTodo) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (state is TodoError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              } else if (state is TodoLoaded) {
                final todos = state.todos;
                if (todos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Todos Found',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                // Choose grid or list based on tablet or phone
                final tablet = isTablet(context);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: tablet
                      ? _buildTodoGrid(todos)
                      : _buildTodoList(todos),
                );
              }
              // If we are in initial or unknown state
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // Build a ListView for phones
  Widget _buildTodoList(List<TodoEntity> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (ctx, i) => TodoCard(todo: todos[i]),
    );
  }

  // Build a GridView for tablets
  Widget _buildTodoGrid(List<TodoEntity> todos) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,      // 2 columns on tablet
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3.0,
      ),
      itemCount: todos.length,
      itemBuilder: (ctx, i) => TodoCard(todo: todos[i]),
    );
  }
}

// A single todo card with interactive design
class TodoCard extends StatefulWidget {
  final TodoEntity todo;
  const TodoCard({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool _hovering = false;

  void _toggleTodo(bool? newValue) {
    // read the bloc and dispatch an update
    context.read<TodoBloc>().add(
      UpdateTodoEvent(widget.todo.id, newValue ?? false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_hovering ? 1.03 : 1.0),
        child: Card(
          color: Colors.white70,
          elevation: _hovering ? 8 : 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: CheckboxListTile(
            title: Text(
              widget.todo.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            value: widget.todo.completed,
            onChanged: _toggleTodo,
          ),
        ),
      ),
    );
  }
}

