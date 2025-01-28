import 'package:dio/dio.dart';

import '../../models/album.dart';


abstract class IRemoteAlbumDataSource {
  Future<List<AlbumModel>> fetchAlbumsByUser(int userId);
}

class RemoteAlbumDataSource implements IRemoteAlbumDataSource {
  final Dio dio;
  RemoteAlbumDataSource({required this.dio});

  @override
  Future<List<AlbumModel>> fetchAlbumsByUser(int userId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/users/$userId/albums');
    final data = response.data as List;
    return data.map((json) => AlbumModel.fromJson(json)).toList();
  }
}
