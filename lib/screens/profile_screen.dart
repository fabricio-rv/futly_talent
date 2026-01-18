import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _loadError;
  Future<void>? _loadFuture;
  String? _loadedForUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[Profile] initState -> maybeStartLoad');
      _maybeStartLoad();
    });
  }

  void _maybeStartLoad({bool force = false}) {
    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    final userId = auth.currentUserId;

    debugPrint(
      '[Profile] auth state: isLoggedIn=${auth.isAuthenticated}, userId=$userId',
    );

    if (!auth.isAuthenticated || userId == null) {
      // Guest mode: never load and never show error.
      setState(() {
        _loadError = null;
        _loadFuture = null;
        _loadedForUserId = null;
      });
      return;
    }

    if (!force && _loadedForUserId == userId && _loadFuture != null) {
      return;
    }

    setState(() {
      _loadError = null;
      _loadedForUserId = userId;
      _loadFuture = _loadWithTimeout(userId);
    });
  }

  Future<void> _loadWithTimeout(String userId) async {
    try {
      await Future.any([
        context.read<UserProvider>().loadProfile(
              userId: userId,
              authUser: context.read<AuthProvider>().currentUser,
              emailHint: context.read<AuthProvider>().currentUser?.email,
            ),
        Future.delayed(const Duration(seconds: 3)).then((_) {
          throw TimeoutException('timeout');
        }),
      ]);
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _loadError = 'Não foi possível carregar o perfil.';
        });
      }
      rethrow;
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadError = 'Não foi possível carregar o perfil.';
        });
      }
      rethrow;
    }
  }

  void _retry() {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) {
      setState(() {
        _loadError = null;
      });
      return;
    }
    _maybeStartLoad(force: true);
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
              const Icon(Icons.person_outline, size: 48),
              const SizedBox(height: 12),
              const Text('Entre para personalizar seu perfil'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.push('/login'),
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => context.push('/register'),
                child: const Text('Criar conta'),
              ),
            ],
          ),
        ),
      );
    }

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(_loadError!),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _retry,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        // If load was never started for some reason, start it once.
        if (_loadFuture == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _maybeStartLoad();
          });
        }

        if (_loadError != null || snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  const Text('Não foi possível carregar o perfil.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done ||
            userProvider.isLoading ||
            userProvider.selectedUser == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = userProvider.selectedUser!;

        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Perfil'),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Publicações'),
                  Tab(text: 'Jogadores criados'),
                  Tab(text: 'Favoritos'),
                  Tab(text: 'Sugestões'),
                  Tab(text: 'Configurações'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _PostsTab(userId: user.id),
                _CreatedPlayersTab(user: user),
                _FavoritesTab(userId: user.id),
                _SuggestionsTab(userId: user.id),
                _SettingsTab(userId: user.id),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PostsTab extends StatelessWidget {
  final String userId;

  const _PostsTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final posts = postProvider.feedPosts
        .where((post) => post.authorId == userId)
        .toList();

    if (posts.isEmpty) {
      return const Center(child: Text('Nenhuma publicação criada.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          child: ListTile(
            onTap: () => context.push('/home/post/${post.id}'),
            title: Text(post.caption ?? 'Post sem legenda'),
            subtitle: Text('${post.likes} curtidas'),
          ),
        );
      },
    );
  }
}

class _CreatedPlayersTab extends StatelessWidget {
  final User user;

  const _CreatedPlayersTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Criar novo jogador'),
          onTap: () => context.push('/home/create-player'),
        ),
        ListTile(
          leading: const Icon(Icons.verified_user_outlined),
          title: const Text('Solicitar verificação'),
          onTap: () => context.push('/home/verification-request'),
        ),
        const SizedBox(height: 12),
        Text(
          'Total criado: ${user.playersCreatedCount}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  final String userId;

  const _FavoritesTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final favorites = playerProvider.favorites;

    if (favorites.isEmpty) {
      return const Center(child: Text('Nenhum jogador favoritado.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final player = favorites[index];
        return Card(
          child: ListTile(
            onTap: () => context.push('/home/player/${player.id}'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(player.photoUrl),
            ),
            title: Text(player.name),
            subtitle: Text(player.positionsDisplay),
          ),
        );
      },
    );
  }
}

class _SuggestionsTab extends StatelessWidget {
  final String userId;

  const _SuggestionsTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.edit_note),
          title: const Text('Nova sugestão'),
          onTap: () => context.push('/home/suggestions/new'),
        ),
        ListTile(
          leading: const Icon(Icons.list_alt),
          title: const Text('Minhas sugestões'),
          onTap: () => context.push('/home/suggestions/list'),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  final String userId;

  const _SettingsTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Configurações da conta'),
          onTap: () => context.push('/home/settings'),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sair da conta'),
          onTap: () async {
            await authProvider.logout();
            if (context.mounted) {
              context.go('/welcome');
            }
          },
        ),
      ],
    );
  }
}
