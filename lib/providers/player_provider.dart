import 'package:flutter/foundation.dart';
import '../services/player_repository.dart';
import '../models/models.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerRepository _repository = PlayerRepository();

  List<Player> _allPlayers = [];
  List<Player> _filteredPlayers = [];
  List<Player> _favorites = [];
  Player? _selectedPlayer;
  bool _isLoading = false;
  SearchFilters? _currentFilters;
  List<String> _recentSearches = [];

  List<Player> get allPlayers => _allPlayers;
  List<Player> get filteredPlayers => _filteredPlayers;
  List<Player> get favorites => _favorites;
  Player? get selectedPlayer => _selectedPlayer;
  bool get isLoading => _isLoading;
  SearchFilters? get currentFilters => _currentFilters;
  List<String> get recentSearches => _recentSearches;

  Future<void> loadAllPlayers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allPlayers = await _repository.getAllPlayers();
      _filteredPlayers = _allPlayers;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadPlayerById(String playerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedPlayer = await _repository.getPlayerById(playerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> searchPlayers(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (query.isNotEmpty) {
        _recentSearches.removeWhere((s) => s == query);
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      }

      _filteredPlayers = await _repository.searchPlayers(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> applyFilters(SearchFilters filters) async {
    _isLoading = true;
    _currentFilters = filters;
    notifyListeners();

    try {
      _filteredPlayers = await _repository.filterPlayers(filters);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearFilters() {
    _currentFilters = null;
    _filteredPlayers = _allPlayers;
    notifyListeners();
  }

  Future<void> favoritePlayer(String playerId, String userId) async {
    try {
      await _repository.favoritePlayer(playerId, userId);

      // Update the player in memory
      final playerIndex = _allPlayers.indexWhere((p) => p.id == playerId);
      if (playerIndex != -1) {
        final player = _allPlayers[playerIndex];
        if (!_favorites.any((p) => p.id == playerId)) {
          _favorites.add(player);
        }
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unfavoritePlayer(String playerId, String userId) async {
    try {
      await _repository.unfavoritePlayer(playerId, userId);
      _favorites.removeWhere((p) => p.id == playerId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadFavorites(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _repository.getFavoritePlayers(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadTrendingPlayers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _filteredPlayers = await _repository.getTrendingPlayers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> createPlayer(Player player) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createPlayer(player);
      _allPlayers.add(player);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  bool isPlayerFavorited(String playerId, String userId) {
    return _allPlayers
        .firstWhere((p) => p.id == playerId, orElse: () => _allPlayers.first)
        .savedByUsers
        .contains(userId);
  }

  void clearSelectedPlayer() {
    _selectedPlayer = null;
    notifyListeners();
  }
}
