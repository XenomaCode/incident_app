import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:incident_app/config/app_routes.dart';
import 'package:incident_app/domain/datasources/incident_datasource.dart';
import 'package:incident_app/domain/providers/incident_provider.dart';
import 'package:provider/provider.dart';
import 'package:incident_app/domain/datasources/auth_datasource.dart';
import 'package:incident_app/domain/providers/auth_provider.dart';
import 'package:incident_app/domain/providers/branch_provider.dart';
import 'package:incident_app/domain/providers/ticket_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Primero cargar las variables de entorno
   await dotenv.load(fileName: ".env");
  
  // Luego crear el authProvider y verificar el estado
  final authProvider = AuthProvider();
  
  await authProvider.checkAuthStatus();
 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins"
      ),
    );
  }
}