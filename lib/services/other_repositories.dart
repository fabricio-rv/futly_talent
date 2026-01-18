import '../models/models.dart';
import 'mock_data_service.dart';

class UserRepository {
  final List<User> _users = MockDataService.generateMockUsers();

  Future<User?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _users
        .where((u) => u.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }
}

class NotificationRepository {
  final List<Notification> _notifications = [];

  Future<List<Notification>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _notifications.where((n) => n.userId == userId).toList();
  }

  Future<void> addNotification(Notification notification) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notifications.add(notification);
  }

  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 150));
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
  }
}

class ConversationRepository {
  final List<Conversation> _conversations = [
    Conversation(
      id: 'conv_1',
      userId: 'user_1',
      participantId: 'user_2',
      messages: [
        Message(
          id: 'msg_1',
          senderId: 'user_2',
          conversationId: 'conv_1',
          text: 'Oi! Como vai? Vimos seu novo scout sobre o Marcus!',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Message(
          id: 'msg_2',
          senderId: 'user_1',
          conversationId: 'conv_1',
          text: 'Oi João! Tudo bem! Sim, ele está impressionando bastante.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  Future<List<Conversation>> getUserConversations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _conversations
        .where((c) => c.userId == userId || c.participantId == userId)
        .toList();
  }

  Future<Conversation?> getConversationWithUser(
    String userId,
    String participantId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _conversations.firstWhere(
        (c) =>
            (c.userId == userId && c.participantId == participantId) ||
            (c.userId == participantId && c.participantId == userId),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> sendMessage(String conversationId, Message message) async {
    await Future.delayed(const Duration(milliseconds: 250));
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
    }
  }

  Future<void> createConversation(Conversation conversation) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _conversations.add(conversation);
  }
}

class SuggestionRepository {
  final List<PlayerSuggestion> _suggestions = [];

  Future<void> createSuggestion(PlayerSuggestion suggestion) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _suggestions.add(suggestion);
  }

  Future<List<PlayerSuggestion>> getUserSuggestions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _suggestions.where((s) => s.suggestedByUserId == userId).toList();
  }

  Future<List<PlayerSuggestion>> getPendingSuggestions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _suggestions.where((s) => s.status == 'pending').toList();
  }
}

class ComparisonRepository {
  final List<Comparison> _comparisons = [];

  Future<void> saveComparison(Comparison comparison) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _comparisons.add(comparison);
  }

  Future<List<Comparison>> getComparisonHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _comparisons;
  }
}
