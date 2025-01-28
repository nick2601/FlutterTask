import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/injection.dart';
import '../../domain/entities/AlbumEntity.dart';
import '../bloc/album/album_bloc.dart';
import '../bloc/album/album_event.dart';
import '../bloc/album/album_state.dart';
import '../utils/helper.dart';
import 'photos_page.dart';


class UserAlbumsPage extends StatefulWidget {
  final int userId;
  const UserAlbumsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserAlbumsPage> createState() => _UserAlbumsPageState();
}

class _UserAlbumsPageState extends State<UserAlbumsPage> {
  late AlbumBloc _albumBloc;

  @override
  void initState() {
    super.initState();
    // Get the AlbumBloc from GetIt and load the user’s albums
    _albumBloc = getIt<AlbumBloc>()..add(LoadAlbumsEvent(widget.userId));
  }

  @override
  void dispose() {
    _albumBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the bloc to the subtree
    return BlocProvider<AlbumBloc>(
      create: (_) => _albumBloc,
      child: Container(
        // Subtle background color or gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<AlbumBloc, AlbumState>(
            builder: (context, state) {
              if (state is AlbumLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (state is AlbumError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              } else if (state is AlbumLoaded) {
                final albums = state.albums;
                if (albums.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Albums Found',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }


                final tablet = isTablet(context);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: tablet
                      ? _buildAlbumGrid(albums)
                      : _buildAlbumList(albums),
                );
              }
              // If the bloc is in initial or unknown state
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // A grid layout for tablets
  Widget _buildAlbumGrid(List<AlbumEntity> albums) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3.0,
      ),
      itemCount: albums.length,
      itemBuilder: (ctx, i) => AlbumCard(album: albums[i]),
    );
  }

  // A list layout for phones
  Widget _buildAlbumList(List<AlbumEntity> albums) {
    return ListView.builder(
      itemCount: albums.length,
      itemBuilder: (ctx, i) => AlbumCard(album: albums[i]),
    );
  }
}

/// A card widget that shows album info with an interactive design
class AlbumCard extends StatefulWidget {
  final AlbumEntity album;
  const AlbumCard({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  bool _hovering = false;

  void _onTap() {
    // Navigate to photos page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotosPage(albumId: widget.album.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // On desktop/web, show a slight hover scale effect
    // On mobile, it will simply show an InkWell ripple on tap
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..scale(_hovering ? 1.03 : 1.0), // scale up on hover
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _onTap,
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: Card(
            color: Colors.white70,
            elevation: _hovering ? 6 : 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  widget.album.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
