import 'package:dio/dio.dart';

import '../../models/photo.dart';

abstract class IRemotePhotoDataSource {
  Future<List<PhotoModel>> fetchPhotosByAlbum(int albumId);
}

class RemotePhotoDataSource implements IRemotePhotoDataSource {
  final Dio dio;
  RemotePhotoDataSource({required this.dio});

  @override
  Future<List<PhotoModel>> fetchPhotosByAlbum(int albumId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/albums/$albumId/photos');
    final data = response.data as List;
    return data.map((json) => PhotoModel.fromJson(json)).toList();
  }
}
