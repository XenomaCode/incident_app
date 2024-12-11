import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: 'userData', value: userData.toString());
  }

  Future<void> clearUserData() async {
    await _storage.delete(key: 'userData');
  }
} 