import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:incident_app/services/storage_service.dart';
import 'package:incident_app/domain/datasources/auth_datasource.dart';
import 'package:flutter/material.dart';
import 'package:incident_app/domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _authDatasource = AuthDatasource();
  final _storageService = StorageService(); 
  
  User? user;
  bool isLoading = false;
  String errorMessage = '';

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final loginResponse = await _authDatasource.login(email, password);
      if (loginResponse != null) {
        user = loginResponse;
        await _storage.write(key: 'token', value: user?.token);
        
        if (user != null) {
          await _storageService.saveUserData(user!.toJson());
          print('Datos guardados en Storage:');
          print('-------------------------');
          print('ID: ${user!.id}');
          print('Nombre: ${user!.name}');
          print('Email: ${user!.email}');
          print('Rol: ${user!.role}');
          print('Token: ${user!.token}');
          print('-------------------------');
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
} 