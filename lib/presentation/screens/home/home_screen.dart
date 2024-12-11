import 'package:flutter/material.dart';
import 'package:incident_app/presentation/screens/home/home_view/home_view.dart';
import 'package:incident_app/presentation/screens/home/map_view/map_view.dart';
import 'package:incident_app/presentation/screens/home/users_view/users_view.dart';
import 'package:incident_app/presentation/screens/home/users_view/branches_view.dart';
import 'package:incident_app/presentation/widgets/shared/buttom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:incident_app/domain/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {

  final int viewIndex; 

  HomeScreen({
    super.key,
    required this.viewIndex
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final routes = [
      const HomeView(),
      const MapView(),
      const UsersView(),
      const BranchesView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: viewIndex >= routes.length ? 0 : viewIndex,
        children: routes,
      ),
      bottomNavigationBar: ButtomNavbar(
        index: viewIndex >= routes.length ? 0 : viewIndex,
        showAdminOptions: true
      ),
    );
  }
}