import 'package:flutter/material.dart';
import 'package:incident_app/domain/datasources/branch_datasource.dart';
import 'package:incident_app/domain/entities/branch.dart';

class BranchProvider extends ChangeNotifier {
  final _branchDatasource = BranchDatasource();
  bool isLoading = false;
  List<Branch> branches = [];

  Future<void> getBranches() async {
    isLoading = true;
    notifyListeners();

    try {
      branches = await _branchDatasource.getBranches();
    } catch (e) {
      print('Error getting branches: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBranch(
    String name,
    String code,
    double lat,
    double lng,
    String managerId,
    String address,
    String phone,
    String email
  ) async {
    isLoading = true;
    notifyListeners();
    
    try {
      final branch = await _branchDatasource.createBranch(
        name, code, lat, lng, managerId, address, phone, email
      );
      if (branch != null) {
        branches.add(branch);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBranch(String id) async {
    try {
      final success = await _branchDatasource.deleteBranch(id);
      if (success) {
        branches.removeWhere((branch) => branch.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateBranch(
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
      final updatedBranch = await _branchDatasource.updateBranch(
        id, name, code, lat, lng, address, phone, email
      );
      if (updatedBranch != null) {
        final index = branches.indexWhere((branch) => branch.id == id);
        if (index != -1) {
          branches[index] = updatedBranch;
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