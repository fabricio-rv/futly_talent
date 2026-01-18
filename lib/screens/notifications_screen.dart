import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<UserProvider>().loadNotifications(auth.currentUserId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();

    if (!authProvider.isAuthenticated) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_none, size: 48),
              const SizedBox(height: 12),
              const Text('Faça login para ver notificações.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _showLoginPrompt(context),
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      );
    }

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.notifications.isEmpty) {
      return const Center(child: Text('Nenhuma notificação ainda.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userProvider.notifications.length,
      itemBuilder: (context, index) {
        final notification = userProvider.notifications[index];
        return Card(
          child: ListTile(
            leading: Icon(
              _iconForType(notification.type),
              color: notification.isRead ? Colors.grey : Colors.blue,
            ),
            title: Text(notification.title),
            subtitle: Text(notification.description ?? ''),
            trailing: notification.isRead
                ? null
                : const Icon(Icons.circle, size: 10, color: Colors.blue),
            onTap: () {
              userProvider.markNotificationAsRead(notification.id);
              if (notification.type == 'post' &&
                  notification.linkedEntityId != null) {
                context.push('/home/post/${notification.linkedEntityId}');
              } else if (notification.type == 'player' &&
                  notification.linkedEntityId != null) {
                context.push('/home/player/${notification.linkedEntityId}');
              }
            },
          ),
        );
      },
    );
  }
}

void _showLoginPrompt(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faça login para continuar',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Agora não'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/login');
                  },
                  child: const Text('Entrar'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

IconData _iconForType(String type) {
  switch (type) {
    case 'comment':
      return Icons.mode_comment_outlined;
    case 'like':
      return Icons.favorite_border;
    case 'follow':
      return Icons.person_add_alt;
    case 'player':
      return Icons.sports_soccer;
    case 'post':
      return Icons.article_outlined;
    default:
      return Icons.notifications;
  }
}
