import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService authService;

  HomeScreen({required this.authService});

  void _logout(BuildContext context) {
    authService.logout();
    Navigator.pushReplacementNamed(context, '/auth_choice');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenue, vous êtes connecté !'),
      ),
    );
  }
}
