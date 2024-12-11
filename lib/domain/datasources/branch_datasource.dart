import 'package:dio/dio.dart';
import 'package:incident_app/config/constants.dart';
import 'package:incident_app/domain/entities/branch.dart';

class BranchDatasource {
  final branchClient = Dio(BaseOptions(
    baseUrl: Constants.baseApiUrl
  ));

  Future<List<Branch>> getBranches() async {
    try {
      final response = await branchClient.get('/branches');
      final List<Branch> branches = (response.data as List)
          .map((branch) => Branch.fromJson(branch))
          .toList();
      return branches;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Branch?> createBranch(
    String name, 
    String code, 
    double lat, 
    double lng, 
    String managerId, 
    String address, 
    String phone,
    String email
  ) async {
    try {
      final response = await branchClient.post('/branches', data: {
        'name': name,
        'code': code,
        'location': {
          'type': 'Point',
          'coordinates': [lng, lat]
        },
        'address': address,
        'phone': phone,
        'email': email,
        'isActive': true
      });
      return Branch.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> deleteBranch(String id) async {
    try {
      await branchClient.delete('/branches/$id');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Branch?> updateBranch(
    String id,
    String name, 
    String code, 
    double lat, 
    double lng, 
    String address, 
    String phone,
    String email
  ) async {
    try {
      final response = await branchClient.put('/branches/$id', data: {
        'name': name,
        'code': code,
        'location': {
          'type': 'Point',
          'coordinates': [lng, lat]
        },
        'address': address,
        'phone': phone,
        'email': email,
        'isActive': true
      });
      return Branch.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }
} 