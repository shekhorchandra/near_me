import 'dart:developer';

import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  StorageService._internal();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'userId';

  late final GetStorage _box;

  // Initialize the storage
  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();

    log('======= GetStorage Initialized =======');
  }

  // Access token
  Future<void> setAccessToken(String token) async {
    await _box.write(_accessTokenKey, token);
  }

  String? get accessToken => _box.read<String>(_accessTokenKey);

  // Refresh token
  Future<void> setRefreshToken(String token) async {
    await _box.write(_refreshTokenKey, token);
  }

  String? get refreshToken => _box.read<String>(_refreshTokenKey);

  // User ID
  Future<void> setUserId(String id) async {
    await _box.write(_userIdKey, id);
  }

  String? get userId => _box.read<String>(_userIdKey);

  // Read data
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  // Read data
  Future<void> write<T>(String key, T value) async {
    return _box.write(key, value);
  }

  // Remove data by key
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  // Clear all stored data
  Future<void> clear() async {
    await _box.erase();
  }
}
