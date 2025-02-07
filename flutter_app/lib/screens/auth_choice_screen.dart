import 'package:flutter/material.dart';

class AuthChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenue')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');  // Redirige vers l'écran d'inscription
              },
              child: Text('S\'inscrire'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');  // Redirige vers l'écran de connexion
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
