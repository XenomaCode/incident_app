import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:incident_app/config/app_routes.dart';

class ButtomNavbar extends StatelessWidget {
  final int index;
  final bool showAdminOptions;

  const ButtomNavbar({
    super.key, 
    required this.index,
    this.showAdminOptions = false,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: index,
      backgroundColor: Colors.transparent,
      items: const [
        Icon(Icons.home),
        Icon(Icons.map),
        Icon(Icons.people),
        Icon(Icons.business),
      ],
      onTap: (index) => context.go('/home/$index'),
    );
  }
}