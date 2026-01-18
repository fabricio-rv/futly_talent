import 'package:flutter/foundation.dart';
import '../services/other_repositories.dart';
import '../models/models.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  final ConversationRepository _conversationRepository =
      ConversationRepository();
  final SuggestionRepository _suggestionRepository = SuggestionRepository();
  final ComparisonRepository _comparisonRepository = ComparisonRepository();

  User? _selectedUser;
  List<Notification> _notifications = [];
  List<Conversation> _conversations = [];
  List<PlayerSuggestion> _suggestions = [];
  List<Comparison> _comparisons = [];
  final Map<String, String> _privateNotes = {};
  bool _isLoading = false;

  User? get selectedUser => _selectedUser;
  List<Notification> get notifications => _notifications;
  List<Conversation> get conversations => _conversations;
  List<PlayerSuggestion> get suggestions => _suggestions;
  List<Comparison> get comparisons => _comparisons;
  bool get isLoading => _isLoading;

  String getPrivateNote(String userId, String playerId) {
    return _privateNotes['${userId}_$playerId'] ?? '';
  }

  void setPrivateNote(String userId, String playerId, String note) {
    _privateNotes['${userId}_$playerId'] = note;
    notifyListeners();
  }

  /// Loads the profile user for the given userId.
  ///
  /// This method is defensive: it always completes, always resets loading,
  /// and provides a fallback user when the repository doesn't contain the id.
  Future<void> loadProfile({
    required String userId,
    User? authUser,
    String? emailHint,
  }) async {
    debugPrint('[Profile] loadProfile start (userId=$userId)');
    _isLoading = true;
    notifyListeners();

    try {
      _selectedUser = authUser ?? await _userRepository.getUserById(userId);

      // Fallback: repository may not know about the generated auth userId.
      _selectedUser ??= User(
        id: userId,
        name: (emailHint != null && emailHint.contains('@'))
            ? emailHint.split('@').first
            : 'Usuário',
        email: emailHint ?? 'usuario@futly.com',
        bio: 'Scout de talentos',
        avatarUrl: 'https://via.placeholder.com/100/1E40AF/FFFFFF?text=U',
        isVerified: false,
        createdAt: DateTime.now(),
        postsCount: 0,
        playersCreatedCount: 0,
        savesCount: 0,
        followers: const [],
        following: const [],
      );
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint('[Profile] loadProfile end (userId=$userId)');
    }
  }

  Future<void> loadUserById(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedUser = await _userRepository.getUserById(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadNotifications(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _notificationRepository.getNotifications(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addNotification(Notification notification) async {
    try {
      await _notificationRepository.addNotification(notification);
      _notifications.insert(0, notification);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationRepository.markAsRead(notificationId);
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final n = _notifications[index];
        _notifications[index] = Notification(
          id: n.id,
          userId: n.userId,
          type: n.type,
          title: n.title,
          description: n.description,
          linkedEntityId: n.linkedEntityId,
          timestamp: n.timestamp,
          isRead: true,
        );
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadConversations(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await _conversationRepository.getUserConversations(
        userId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> sendMessage(String conversationId, Message message) async {
    try {
      await _conversationRepository.sendMessage(conversationId, message);

      final conversationIndex = _conversations.indexWhere(
        (c) => c.id == conversationId,
      );
      if (conversationIndex != -1) {
        final conversation = _conversations[conversationIndex];
        _conversations[conversationIndex] = Conversation(
          id: conversation.id,
          userId: conversation.userId,
          participantId: conversation.participantId,
          messages: [...conversation.messages, message],
          lastMessageTime: message.timestamp,
        );

        // Move to top
        _conversations.removeAt(conversationIndex);
        _conversations.insert(0, conversation);
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createConversation(String userId, String participantId) async {
    try {
      final conversation = Conversation(
        id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        participantId: participantId,
        messages: [],
        lastMessageTime: DateTime.now(),
      );

      await _conversationRepository.createConversation(conversation);
      _conversations.insert(0, conversation);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createSuggestion(PlayerSuggestion suggestion) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _suggestionRepository.createSuggestion(suggestion);
      _suggestions.insert(0, suggestion);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadUserSuggestions(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _suggestions = await _suggestionRepository.getUserSuggestions(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> saveComparison(Comparison comparison) async {
    try {
      await _comparisonRepository.saveComparison(comparison);
      _comparisons.insert(0, comparison);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadComparisonHistory(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _comparisons = await _comparisonRepository.getComparisonHistory(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }

  /// Set user directly from auth provider (used during login/register)
  void setCurrentUserFromAuth(User user) {
    _selectedUser = user;
    notifyListeners();
  }
}
