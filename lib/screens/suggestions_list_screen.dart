import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

class SuggestionsListScreen extends StatefulWidget {
  const SuggestionsListScreen({super.key});

  @override
  State<SuggestionsListScreen> createState() => _SuggestionsListScreenState();
}

class _SuggestionsListScreenState extends State<SuggestionsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<UserProvider>().loadUserSuggestions(auth.currentUserId!);
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
        title: const Text('Minhas sugestões'),
      ),
      body: authProvider.isAuthenticated
          ? _buildList(userProvider)
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
            const Icon(Icons.list_alt, size: 48),
            const SizedBox(height: 12),
            const Text('Faça login para ver sugestões.'),
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

  Widget _buildList(UserProvider userProvider) {
    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.suggestions.isEmpty) {
      return const Center(child: Text('Nenhuma sugestão enviada.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userProvider.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = userProvider.suggestions[index];
        return Card(
          child: ListTile(
            title: Text(suggestion.name),
            subtitle: Text('${suggestion.club} • ${suggestion.country}'),
            trailing: Chip(label: Text(suggestion.status)),
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
