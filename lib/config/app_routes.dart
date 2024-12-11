import 'package:go_router/go_router.dart';
import 'package:incident_app/presentation/screens/home/home_screen.dart';
import 'package:incident_app/presentation/screens/auth/login_screen.dart';
import 'package:incident_app/presentation/screens/auth/register_screen.dart';
import 'package:incident_app/domain/providers/auth_provider.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLogged = authProvider.user != null;
    
    if (!isLogged && state.uri.path != '/login') {
      return '/login';
    }
    
    if (isLogged && state.uri.path == '/login') {
      return '/home/0';
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/home/:view",
      builder: (context, state) {
        final viewIndex = int.parse(state.pathParameters["view"] ?? '0');
        return HomeScreen(viewIndex: viewIndex);
      }
    )
  ]
);