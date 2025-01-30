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
  Future<bool> login(String email, String password) async {
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

        print('✅ Connexion réussie, token sauvegardé.');
        return true;
      }

      return false;
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      return false;
    }
  }

  // Méthode d'inscription avec connexion automatique
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      // Vérification si l'inscription a réussi
      if (response.statusCode == 201) {
        // Connexion immédiate après l'inscription
        bool loginSuccess = await login(email, password); // Appel de la méthode login pour connecter l'utilisateur

        if (loginSuccess) {
          return true;  // Inscription réussie et l'utilisateur est connecté
        } else {
          throw Exception("Connexion échouée après l'inscription");  // Gérer l'échec de la connexion
        }
      } else {
        throw Exception('Erreur d\'inscription');
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      throw Exception('Erreur d\'inscription');
    }
  }

  // Déconnexion de l'utilisateur
  Future<void> logout() async {
    try {
      await _dio.post('/logout'); // Déconnexion côté serveur

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token'); // Supprimer le token localement

      _token = null;
      _dio.options.headers.remove('Authorization');

      print('✅ Déconnexion réussie.');
    } catch (e) {
      print('❌ Erreur lors de la déconnexion: $e');
    }
  }
}
