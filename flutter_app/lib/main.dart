import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/login_screen.dart';
// import 'package:flutter_app/screens/register_screen.dart';
import 'package:flutter_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  await authService.loadToken();  // Charger le token d'authentification

  runApp(MyApp(authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  MyApp(this.authService);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackTime',
      home: AuthRedirect(authService: authService),
      routes: {
        '/home': (context) => HomeScreen(authService: authService),
        '/login': (context) => LoginScreen(), // authService: authService
        // '/register': (context) => RegisterScreen(authService: authService),
      },
    );
  }
}

class AuthRedirect extends StatelessWidget {
  final AuthService authService;

  AuthRedirect({required this.authService});

  @override
  Widget build(BuildContext context) {
    // Vérifier l'état de connexion
    if (authService.isAuthenticated()) {
      // Rediriger vers la page d'accueil si l'utilisateur est connecté
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/home');
      });
    } else {
      // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    // Afficher un indicateur de chargement pendant le temps de vérification
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
