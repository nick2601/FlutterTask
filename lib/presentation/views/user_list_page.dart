// presentation/pages/user_list_page.dart
import 'package:assignment/presentation/views/user_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../../domain/entities/UserEntity.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';
import '../utils/helper.dart';
import '../widgets/GradientBackground.dart';


class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final UserBloc _userBloc;
  final _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userBloc = getIt<UserBloc>()..add(LoadUsersEvent());
  }

  @override
  void dispose() {
    _userBloc.close();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (_) => _userBloc,
      child: Scaffold(
        // We'll wrap the entire content in a gradient background
        body: GradientBackground(
          child: SafeArea(
            child: Column(
              children: [
                // Title + actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Users',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.sort_by_alpha, color: Colors.white),
                        onPressed: () => _userBloc.add(SortUsersEvent()),
                      ),
                    ],
                  ),
                ),
                // Filter text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _filterController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Filter by username',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      _userBloc.add(FilterUsersEvent(val));
                    },
                  ),
                ),
                // User list or grid
                Expanded(
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      } else if (state is UserLoaded) {
                        final users = state.users;
                        if (users.isEmpty) {
                          return const Center(
                            child: Text(
                              'No users found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }
                        // Responsive: grid if tablet, list if phone
                        final tablet = isTablet(context);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: tablet
                              ? GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 3,
                            ),
                            itemCount: users.length,
                            itemBuilder: (ctx, i) {
                              final user = users[i];
                              return UserCard(user: user);
                            },
                          )
                              : ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (ctx, i) {
                              final user = users[i];
                              return UserCard(user: user);
                            },
                          ),
                        );
                      } else if (state is UserError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A small widget to display a user in a fancy card
class UserCard extends StatelessWidget {
  final UserEntity user;
  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tapping goes to user detail
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UserDetailPage(user: user),
        ));
      },
      child: Card(
        elevation: 3,
        color: Colors.white54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text('@${user.username}', style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 4),
                Text(user.email, style: const TextStyle(color: Colors.black45)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
