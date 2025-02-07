import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final AuthService authService;

  RegisterScreen({required this.authService});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;


  // Faire la vérification de la taille du mot de passe min et de la validité de l'email au fur et a mesure de la saisie, comme du JS ?
  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les mots de passe ne correspondent pas.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try 
    {
      Map<String, dynamic> response = await widget.authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      // Vérifier si l'inscription a réussi
      if(response['success']) 
      {
        // Vérifier si l'utilisateur bien connecté
        if (response['login']) 
        {
          Navigator.pushReplacementNamed(context, '/home');
          return;
        } 
        else 
        {
          Navigator.pushReplacementNamed(context, '/login');
          return;
        }
      }
      else
      {
        // Afficher le(s) message(s) d'erreur
        dynamic errorMessage;

        if (response['errors'] is Map) 
        {
          var errors = response['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.map((e) => e.join('\n')).join('\n');
        }
        else 
        {
          errorMessage = response['errors'];
        }

        // Modifier le système qui affiche les messages d'erreur, les mettres en dur pour pas qu'elles disparaissent
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
        title: const Text('Créer un compte'),
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
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmer le mot de passe',
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text('S\'inscrire'),
                  ),
          ],
        ),
      ),
    );
  }
}
