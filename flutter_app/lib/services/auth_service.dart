import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:7000/api', 
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  String? _token;

  // Méthode pour charger le token d'authentification
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    if (_token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_token';
    }
  }

  // Méthode pour vérifier si l'utilisateur est authentifié
  bool isAuthenticated() {
    return _token != null;  // L'utilisateur est authentifié si un token est présent
  }

  // Connexion de l'utilisateur
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data != null && response.data['token'] != null) {
        _token = response.data['token'];

        // Sauvegarde du token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        // Ajout du token dans les headers pour les prochaines requêtes
        _dio.options.headers['Authorization'] = 'Bearer $_token';

        return {"success": true};
      }

      // Voir comment ca se passe quand les informations sont incorrectes, retour code de l'api ?

      return {"success": false, "errors": "Une erreur est survenue lors de la connexion. Veuillez réessayer."};
    } catch (e) {
      return {"success": false, "errors": "Une erreur est survenue lors de la connexion. Veuillez réessayer."};
    }
  }

  // Méthode d'inscription avec connexion automatique
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      // Connecté l'utilisateur si l'inscritpion est réussie
      if (response.statusCode == 201) {
        // Connexion immédiate après l'inscription
        Map<String, dynamic> loginSuccess = await login(email, password); // Appel de la méthode login pour connecter l'utilisateur

        // Vérifie si l'utilisateur est connecté
        return {"success": true, "login": loginSuccess["success"]};
      }

      return {"success": false, "errors": "Une erreur est survenue lors de l'inscription. Veuillez réessayer."};
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422 && e.response?.data != null) {
        // Récupérer les erreurs du serveur
        final errors = e.response?.data['error'] ?? {};

        // Renvoyer les erreurs
        return {"success": false, "errors": errors};
      }

      // Renvoie d'une information générique en cas d'erreur non gérée
      return {"success": false, "errors": "Une erreur est survenue lors de l'inscription. Veuillez réessayer."};
    }
  }

  // Déconnexion de l'utilisateur
  Future<Map<String, dynamic>> logout() async {
    try {
      await _dio.post('/logout'); // Déconnexion côté serveur

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token'); // Supprimer le token localement

      _token = null;
      _dio.options.headers.remove('Authorization');

      // Déconnexion réussie
      return {"success": true};
    } catch (e) {
      // Essayer de voir les possibles erreur en retour pour traiter les messages d'erreurs
      return {"success": false, "errors" : "Une erreur est survenue lors de la déconnexion. Veuillez réessayer."};
    }
  }
}
