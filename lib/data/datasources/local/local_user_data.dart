import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';

abstract class ILocalUserDataSource {
  /// Returns a cached list of [UserModel] if present, or `null` if nothing is cached.
  Future<List<UserModel>?> getCachedUsers();

  /// Caches a list of [UserModel] in SharedPreferences as JSON.
  Future<void> cacheUsers(List<UserModel> users);
}

class LocalUserDataSource implements ILocalUserDataSource {
  static const _cacheKey = 'CACHED_USERS';

  final SharedPreferences prefs;
  LocalUserDataSource(this.prefs);

  @override
  Future<List<UserModel>?> getCachedUsers() async {
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString == null) return null;

    final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {

    final listMap = users.map((u) => {
      'id': u.id,
      'name': u.name,
      'username': u.username,
      'email': u.email,
    }).toList();

    final jsonString = jsonEncode(listMap);
    await prefs.setString(_cacheKey, jsonString);
  }
}
