import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

class DmListScreen extends StatefulWidget {
  const DmListScreen({super.key});

  @override
  State<DmListScreen> createState() => _DmListScreenState();
}

class _DmListScreenState extends State<DmListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<UserProvider>().loadConversations(auth.currentUserId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Mensagens'),
      ),
      body: authProvider.isAuthenticated
          ? _buildConversationList(context, userProvider)
          : _buildLoginPrompt(context),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 48),
            const SizedBox(height: 12),
            const Text('Faça login para acessar mensagens.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showLoginPrompt(context),
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Agora não'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationList(
    BuildContext context,
    UserProvider userProvider,
  ) {
    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.conversations.isEmpty) {
      return const Center(child: Text('Nenhuma conversa encontrada.'));
    }

    return ListView.builder(
      itemCount: userProvider.conversations.length,
      itemBuilder: (context, index) {
        final conversation = userProvider.conversations[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              conversation.participantId.isNotEmpty
                  ? conversation.participantId[0]
                  : '?',
            ),
          ),
          title: Text('Usuário ${conversation.participantId}'),
          subtitle: conversation.messages.isNotEmpty
              ? Text(conversation.messages.last.text)
              : const Text('Sem mensagens'),
          trailing: Text(
            '${conversation.lastMessageTime.hour.toString().padLeft(2, '0')}:${conversation.lastMessageTime.minute.toString().padLeft(2, '0')}',
          ),
          onTap: () => context.push('/home/dm/${conversation.participantId}'),
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
