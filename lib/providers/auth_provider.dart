import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/other_repositories.dart';
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  String? _currentUserId;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isGuest = false;

  final UserRepository _userRepository = UserRepository();

  String? get currentUserId => _currentUserId;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUserId != null;
  bool get isGuest => _isGuest;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final isGuest = prefs.getBool('isGuest') ?? false;
      _isGuest = isGuest;
      if (userId != null) {
        _currentUserId = userId;
        await _loadCurrentUser();
      }
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar autenticação';
    }
  }

  Future<void> setGuest() async {
    try {
      _currentUserId = null;
      _currentUser = null;
      _isGuest = true;
      _error = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('userEmail');
      await prefs.setBool('isGuest', true);
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao ativar modo visitante';
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    if (_currentUserId != null) {
      _currentUser = await _userRepository.getUserById(_currentUserId!);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Mock login - simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock: Any email/password combination works (demo)
      _currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _isGuest = false;

      // Set current user as the first mock user for simplicity
      _currentUser = User(
        id: _currentUserId!,
        name: email.split('@').first,
        email: email,
        bio: 'Scout de talentos',
        avatarUrl:
            'https://via.placeholder.com/100/1E40AF/FFFFFF?text=${email[0].toUpperCase()}',
        isVerified: false,
        createdAt: DateTime.now(),
        postsCount: 0,
        playersCreatedCount: 0,
        savesCount: 0,
        followers: [],
        following: [],
      );

      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _currentUserId!);
      await prefs.setString('userEmail', email);
      await prefs.setBool('isGuest', false);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao fazer login: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (password != confirmPassword) {
        _error = 'Senhas não coincidem';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await Future.delayed(const Duration(milliseconds: 1000));

      _currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _isGuest = false;
      _currentUser = User(
        id: _currentUserId!,
        name: name,
        email: email,
        bio: 'Scout de talentos',
        avatarUrl:
            'https://via.placeholder.com/100/059669/FFFFFF?text=${name[0].toUpperCase()}',
        isVerified: false,
        createdAt: DateTime.now(),
        postsCount: 0,
        playersCreatedCount: 0,
        savesCount: 0,
        followers: [],
        following: [],
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _currentUserId!);
      await prefs.setString('userEmail', email);
      await prefs.setBool('isGuest', false);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao registrar: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      // Mock: always succeeds
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao resetar senha: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('userEmail');
      await prefs.remove('isGuest');

      _currentUserId = null;
      _currentUser = null;
      _isGuest = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao fazer logout: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
