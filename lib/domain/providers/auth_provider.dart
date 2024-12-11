import 'package:flutter/material.dart';
import 'package:incident_app/domain/datasources/auth_datasource.dart';
import 'package:incident_app/domain/entities/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:incident_app/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _authDatasource = AuthDatasource();
  final _storageService = StorageService();
  
  User? user;
  bool isLoading = false;
  String errorMessage = '';
  List<User> users = [];

  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      try {
        user = await _authDatasource.checkAuth(token);
        notifyListeners();
      } catch (e) {
        await _storage.delete(key: 'token');
      }
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final loginResponse = await _authDatasource.login(email, password);
      final token = loginResponse['token'];
      final userData = loginResponse['user'];
      
      // Crear objeto User con los datos correctos
      user = User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        role: userData['role'],
        token: token,
      );

      // Guardar token
      await _storage.write(key: 'token', value: token);
      
      // Guardar datos del usuario y mostrar en consola
      final userDataToStore = user!.toJson();
      await _storageService.saveUserData(userDataToStore);
      
      print('Datos guardados en Storage:');
      print('-------------------------');
      print('ID: ${userDataToStore['id']}');
      print('Nombre: ${userDataToStore['name']}');
      print('Email: ${userDataToStore['email']}');
      print('Rol: ${userDataToStore['role']}');
      print('Token: ${userDataToStore['token']}');
      print('-------------------------');
      
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    user = null;
    notifyListeners();
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final newUser = await _authDatasource.register(userData);
      if (newUser != null) {
        users.add(newUser);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error en registro: $e');
      return false;
    }
  }

  Future<List<User>> getUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      users = await _authDatasource.getUsers();
      return users;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      final success = await _authDatasource.deleteUser(id);
      if (success) {
        users.removeWhere((user) => user.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUser(String id, String name, String email, String role) async {
    try {
      final updatedUser = await _authDatasource.updateUser(id, {
        'name': name,
        'email': email,
        'role': role,
        'isActive': true
      });
      if (updatedUser != null) {
        final index = users.indexWhere((user) => user.id == id);
        if (index != -1) {
          users[index] = updatedUser;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
} 