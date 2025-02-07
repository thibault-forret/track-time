import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  LoginScreen({required this.authService});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try 
    {
      Map<String, dynamic> response = await widget.authService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (response['success']) 
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion réussie.')),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } 
      else 
      {
        // Gérez lorsque les infos de connexion sont incorrectes
        
        var errorMessage = response['errors'] ?? 'Une erreur est survenue lors de la connexion. Veuillez réessayer.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } 
    catch (e) 
    {
      String errorMessage = "Une erreur est survenue. Veuillez réessayer.";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } 
    finally 
    {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Se connecter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Se connecter'),
                  ),
          ],
        ),
      ),
    );
  }
}
