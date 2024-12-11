import 'package:dio/dio.dart';
import 'package:incident_app/config/constants.dart';
import 'package:incident_app/domain/entities/user.dart';

class AuthDatasource {
  final authClient = Dio(BaseOptions(
    baseUrl: Constants.baseApiUrl
  ));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await authClient.post('/users/login', data: {
        'email': email,
        'password': password
      });
      return response.data;
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }

  Future<User?> register(Map<String, dynamic> userData) async {
    try {
      final response = await authClient.post('/users/', data: userData);
      return User.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> checkAuth(String token) async {
    try {
      final response = await authClient.get('/auth/check-status', 
        options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      
      return User.fromJson(response.data['user']);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final response = await authClient.get('/users');
      final List<User> users = (response.data as List)
          .map((user) => User.fromJson(user))
          .toList();
      return users;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      await authClient.delete('/users/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> updateUser(String id, Map<String, dynamic> userData) async {
    try {
      final response = await authClient.put('/users/$id', data: userData);
      return User.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
} 