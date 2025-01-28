import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/injection.dart';
import '../../domain/entities/CommentEntity.dart';
import '../bloc/comment/comment_bloc.dart';
import '../bloc/comment/comment_event.dart';
import '../bloc/comment/comment_state.dart';

class CommentsPage extends StatefulWidget {
  final int postId;
  const CommentsPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late CommentBloc _commentBloc;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentBloc = getIt<CommentBloc>()..add(LoadCommentsEvent(widget.postId));
  }

  @override
  void dispose() {
    _commentBloc.close();
    _nameController.dispose();
    _emailController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _addComment() {
    final newComment = CommentEntity(
      postId: widget.postId,
      id: 9999, // placeholder
      name: _nameController.text,
      email: _emailController.text,
      body: _bodyController.text,
    );
    _commentBloc.add(AddCommentEvent(newComment));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentBloc>(
      create: (_) => _commentBloc,
      child: Scaffold(
        // We remove or override default AppBar so we can do a custom top row with a back button
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.cyanAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top row with back arrow + title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Comments on post #${widget.postId}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) {
                      if (state is CommentLoading) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      } else if (state is AddingComment) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      } else if (state is CommentLoaded) {
                        final comments = state.comments;
                        if (comments.isEmpty) {
                          return const Center(
                            child: Text(
                              'No comments found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }
                        // If you'd like a grid for tablet, you could do so. Here we just use a list:
                        return ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (_, i) {
                            final c = comments[i];
                            return _CommentCard(comment: c);
                          },
                        );
                      } else if (state is CommentAdded) {
                        final posted = state.postedComment;
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                'Successfully posted comment!',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Card(
                                child: ListTile(
                                  title: Text('${posted.name}  (${posted.email})'),
                                  subtitle: Text(posted.body),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // reload the comments from server
                                  _commentBloc.add(LoadCommentsEvent(widget.postId));
                                },
                                child: const Text('Reload comments'),
                              )
                            ],
                          ),
                        );
                      } else if (state is CommentError) {
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

                // Form for a new comment
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: _bodyController,
                        decoration: const InputDecoration(labelText: 'Comment'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text('Post Comment'),
                        onPressed: _addComment,
                      ),
                    ],
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

// Optional: a single comment card with a hover effect
class _CommentCard extends StatefulWidget {
  final CommentEntity comment;
  const _CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  State<_CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_hovering ? 1.02 : 1.0),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text('${widget.comment.name}  (${widget.comment.email})'),
            subtitle: Text(widget.comment.body),
          ),
        ),
      ),
    );
  }
}
