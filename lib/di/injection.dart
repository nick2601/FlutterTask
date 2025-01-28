import 'package:assignment/domain/usecases/fetch_album_usecase.dart';
import 'package:assignment/domain/usecases/fetch_comment_usecase.dart';
import 'package:assignment/domain/usecases/fetch_photo_usecase.dart';
import 'package:assignment/domain/usecases/fetch_post_usecase.dart';
import 'package:assignment/domain/usecases/fetch_todos_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/local/local_album_data.dart';
import '../data/datasources/local/local_comment_data.dart';
import '../data/datasources/local/local_photo_data.dart';
import '../data/datasources/local/local_post_data.dart';
import '../data/datasources/local/local_todos_data.dart';
import '../data/datasources/local/local_user_data.dart';
import '../data/datasources/remote/remote_album.dart';
import '../data/datasources/remote/remote_comment.dart';
import '../data/datasources/remote/remote_photo.dart';
import '../data/datasources/remote/remote_post.dart';
import '../data/datasources/remote/remote_todos.dart';
import '../data/datasources/remote/remote_user.dart';
import '../data/repositoriesImpl/albumrepo_impl.dart';
import '../data/repositoriesImpl/commentsrepo_impl.dart';
import '../data/repositoriesImpl/photosrepo_impl.dart';
import '../data/repositoriesImpl/postrepo_impl.dart';
import '../data/repositoriesImpl/todosrepo_impl.dart';
import '../data/repositoriesImpl/userrepo_impl.dart';
import '../domain/repositories/album_repository.dart';
import '../domain/repositories/comment_repository.dart';
import '../domain/repositories/photo_repository.dart';
import '../domain/repositories/post_repository.dart';
import '../domain/repositories/todo_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/add_comment_usecase.dart';
import '../domain/usecases/fetch_users_usecase.dart';
import '../domain/usecases/update_todo_usecase.dart';
import '../presentation/bloc/album/album_bloc.dart';
import '../presentation/bloc/comment/comment_bloc.dart';
import '../presentation/bloc/photos/photos_bloc.dart';
import '../presentation/bloc/post/post_bloc.dart';
import '../presentation/bloc/todos/todos_bloc.dart';
import '../presentation/bloc/user/user_bloc.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  // 1) External dependencies
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  getIt.registerLazySingleton<Dio>(() => Dio());

  // 2) Register local data sources
  getIt.registerLazySingleton<ILocalUserDataSource>(
    () => LocalUserDataSource(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ILocalAlbumDataSource>(
    () => LocalAlbumDataSource(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ILocalPhotoDataSource>(
    () => LocalPhotoDataSource(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ILocalPostDataSource>(
    () => LocalPostDataSource(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ILocalCommentDataSource>(
    () => LocalCommentDataSource(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ILocalTodoDataSource>(
    () => LocalTodoDataSource(getIt<SharedPreferences>()),
  );

  // 3) Register remote data sources
  getIt.registerLazySingleton<IRemoteUserDataSource>(
    () => RemoteUserDataSource(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<IRemoteAlbumDataSource>(
    () => RemoteAlbumDataSource(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<IRemotePhotoDataSource>(
    () => RemotePhotoDataSource(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<IRemotePostDataSource>(
    () => RemotePostDataSource(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<IRemoteCommentDataSource>(
    () => RemoteCommentDataSource(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<IRemoteTodoDataSource>(
    () => RemoteTodoDataSource(dio: getIt<Dio>()),
  );

  // 4) Register repositories (which depend on both local & remote)
  getIt.registerLazySingleton<IUserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt<IRemoteUserDataSource>(),
      localDataSource: getIt<ILocalUserDataSource>(),
    ),
  );
  getIt.registerLazySingleton<IAlbumRepository>(
    () => AlbumRepositoryImpl(
      remoteDataSource: getIt<IRemoteAlbumDataSource>(),
      localDataSource: getIt<ILocalAlbumDataSource>(),
    ),
  );
  getIt.registerLazySingleton<IPhotoRepository>(
    () => PhotoRepositoryImpl(
      remoteDataSource: getIt<IRemotePhotoDataSource>(),
      localDataSource: getIt<ILocalPhotoDataSource>(),
    ),
  );
  getIt.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: getIt<IRemotePostDataSource>(),
      localDataSource: getIt<ILocalPostDataSource>(),
    ),
  );
  getIt.registerLazySingleton<ICommentRepository>(
    () => CommentRepositoryImpl(
      remoteDataSource: getIt<IRemoteCommentDataSource>(),
      localDataSource: getIt<ILocalCommentDataSource>(),
    ),
  );
  getIt.registerLazySingleton<ITodoRepository>(
    () => TodoRepositoryImpl(
      remoteDataSource: getIt<IRemoteTodoDataSource>(),
      localDataSource: getIt<ILocalTodoDataSource>(),
    ),
  );

//Register UseCases to retrieve the functions

  getIt.registerLazySingleton<FetchUsersUseCase>(
    () => FetchUsersUseCase(getIt<IUserRepository>()),
  );

  getIt.registerLazySingleton<FetchAlbumsUseCase>(
    () => FetchAlbumsUseCase(getIt<IAlbumRepository>()),
  );

  getIt.registerLazySingleton<FetchPostsUseCase>(
    () => FetchPostsUseCase(getIt<IPostRepository>()),
  );
  getIt.registerLazySingleton<FetchTodosUseCase>(
    () => FetchTodosUseCase(getIt<ITodoRepository>()),
  );
  getIt.registerLazySingleton<FetchCommentsUseCase>(
    () => FetchCommentsUseCase(getIt<ICommentRepository>()),
  );
  getIt.registerLazySingleton<FetchPhotosUseCase>(
    () => FetchPhotosUseCase(getIt<IPhotoRepository>()),
  );

  getIt.registerLazySingleton<AddCommentUseCase>(
    () => AddCommentUseCase(getIt<ICommentRepository>()),
  );

  getIt.registerLazySingleton<UpdateTodoUseCase>(
    () => UpdateTodoUseCase(getIt<ITodoRepository>()),
  );
  // 5. BLoCs
  getIt.registerFactory<UserBloc>(
    () => UserBloc(fetchUsersUseCase: getIt()),
  );

  getIt.registerFactory<AlbumBloc>(
    () => AlbumBloc(fetchAlbumsUseCase: getIt()),
  );

  getIt.registerFactory<PhotoBloc>(
    () => PhotoBloc(fetchPhotosUseCase: getIt()),
  );

  getIt.registerFactory<PostBloc>(
    () => PostBloc(fetchPostsUseCase: getIt()),
  );

  getIt.registerFactory<CommentBloc>(
    () =>
        CommentBloc(fetchCommentsUseCase: getIt(),addCommentUseCase: getIt()),
  );

  getIt.registerFactory<TodoBloc>(
    () => TodoBloc(
      fetchTodosUseCase: getIt<FetchTodosUseCase>(),updateTodoUseCase: getIt<UpdateTodoUseCase>(),
    ),
  );
}
