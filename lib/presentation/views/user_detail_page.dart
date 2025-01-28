// presentation/pages/user_detail_page.dart
import 'package:assignment/presentation/views/post_list_page.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/UserEntity.dart';
import 'user_albums_page.dart';
import 'user_todos_page.dart';

class UserDetailPage extends StatelessWidget {
  final UserEntity user;
  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.name),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Albums'),
              Tab(text: 'Posts'),
              Tab(text: 'Todos'),
            ],
          ),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background.withOpacity(0.9),
          child: TabBarView(
            children: [
              UserAlbumsPage(userId: user.id),
              UserPostsPage(userId: user.id,name: user.name,),
              UserTodosPage(userId: user.id),
            ],
          ),
        ),
      ),
    );
  }
}
