import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/injection.dart';
import '../../domain/entities/PhotoEntity.dart';
import '../bloc/photos/photos_bloc.dart';
import '../bloc/photos/photos_event.dart';
import '../bloc/photos/photos_state.dart';
import '../utils/helper.dart';


class PhotosPage extends StatefulWidget {
  final int albumId;
  const PhotosPage({Key? key, required this.albumId}) : super(key: key);

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  late PhotoBloc _photoBloc;

  @override
  void initState() {
    super.initState();
    _photoBloc = getIt<PhotoBloc>()..add(LoadPhotosEvent(widget.albumId));
  }

  @override
  void dispose() {
    _photoBloc.close();
    super.dispose();
  }

  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);

    return BlocProvider<PhotoBloc>(
      create: (_) => _photoBloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Photos for album ${widget.albumId}')),
        body: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PhotoLoaded) {
              final photos = state.photos;
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: tablet ? 4 : 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photos.length,
                itemBuilder: (ctx, i) {
                  final photo = photos[i];
                  return _PhotoTile(photo: photo);
                },
              );
            } else if (state is PhotoError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _PhotoTile extends StatefulWidget {
  final PhotoEntity photo;
  const _PhotoTile({Key? key, required this.photo}) : super(key: key);

  @override
  State<_PhotoTile> createState() => _PhotoTileState();
}

class _PhotoTileState extends State<_PhotoTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_hovering ? 1.05 : 1.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: GridTile(
          child: Image.network(widget.photo.thumbnailUrl, fit: BoxFit.cover),
          footer: GridTileBar(
            backgroundColor: Colors.black38,
            title: Text(widget.photo.title, style: const TextStyle(fontSize: 12)),
          ),
        ),
      ),
    );
  }
}
