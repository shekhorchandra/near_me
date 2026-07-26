import 'dart:developer';

import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  StorageService._internal();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'userId';
  static const String _planIdKey = 'planId';

  static const String _serviceIdKey = 'serviceId';

  final GetStorage _box = GetStorage();

  // Initialize the storage
  Future<void> init() async {
    await GetStorage.init();
    log('======= GetStorage Initialized =======');
  }

  Future<void> setPlanId(String id) async {
    await _box.write(_planIdKey, id);
  }

  String? get planId => _box.read<String>(_planIdKey);

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

  Future<void> setServiceId(String id) async {
    await _box.write(_serviceIdKey, id);
  }

  String? get serviceId => _box.read<String>(_serviceIdKey);

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
