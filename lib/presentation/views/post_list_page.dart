import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/injection.dart';
import '../../domain/entities/PostEntity.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import '../bloc/post/post_state.dart';
import '../utils/helper.dart';
import 'comments_page.dart';

class UserPostsPage extends StatefulWidget {
  final int userId;
  final String name;
  const UserPostsPage({Key? key, required this.userId, required this.name}) : super(key: key);

  @override
  State<UserPostsPage> createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  late PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = getIt<PostBloc>()..add(LoadPostsEvent(widget.userId));
  }

  @override
  void dispose() {
    _postBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (_) => _postBloc,
      child: Scaffold(
        // We replace the plain color with a gradient
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // A top row (similar to an AppBar) for styling
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Posts for ${widget.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                // The main content area
                Expanded(
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      if (state is PostLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      } else if (state is PostLoaded) {
                        final posts = state.posts;
                        if (posts.isEmpty) {
                          return const Center(
                            child: Text(
                              'No posts found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }
                        // Decide list or grid based on tablet
                        final tablet = isTablet(context);
                        return tablet
                            ? _buildGrid(posts)
                            : _buildList(posts);
                      } else if (state is PostError) {
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

  Widget _buildList(List<PostEntity> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (_, i) {
        return PostCard(post: posts[i]);
      },
    );
  }

  Widget _buildGrid(List<PostEntity> posts) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // 2 columns on tablet
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3.0,
      ),
      itemCount: posts.length,
      itemBuilder: (_, i) => PostCard(post: posts[i]),
    );
  }
}

class PostCard extends StatefulWidget {
  final PostEntity post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _hovering = false;

  void _goToComments() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommentsPage(postId: widget.post.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We'll do a hover scale effect on desktop, with an InkWell ripple for mobile
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_hovering ? 1.03 : 1.0),
        curve: Curves.easeInOut,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: _hovering ? 6 : 3,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _goToComments,
            splashColor: Colors.deepPurple.shade100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text(
                  widget.post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(widget.post.body),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
