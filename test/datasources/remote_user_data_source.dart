import 'package:assignment/data/datasources/remote/remote_user.dart';
import 'package:assignment/data/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';


class MockDio extends Mock implements Dio {}

void main() {
  late RemoteUserDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = RemoteUserDataSource(dio: mockDio);
  });

  test('fetchUsers returns List<UserModel> on success', () async {
    final tJson = [
      {
        'id': 1,
        'name': 'TestUser1',
        'username': 'test1',
        'email': 'test1@example.com'
      }
    ];

    when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: tJson,
        statusCode: 200,
      ),
    );

    final result = await dataSource.fetchUsers();

    expect(result, isA<List<UserModel>>());
    expect(result.first.id, 1);
    verify(() => mockDio.get('https://jsonplaceholder.typicode.com/users')).called(1);
  });

  test('throws exception if status code not 200', () async {
    when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: 'Something went wrong',
        statusCode: 404,
      ),
    );

    expect(() => dataSource.fetchUsers(), throwsException);
  });
}
