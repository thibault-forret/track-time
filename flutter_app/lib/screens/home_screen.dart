import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService authService;

  HomeScreen({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue, vous êtes connecté !'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Appel de la méthode logout pour déconnecter l'utilisateur
                await authService.logout();

                // Ajouter un chargement pendant la déconnexion

                // Rediriger vers la page de connexion après la déconnexion
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
