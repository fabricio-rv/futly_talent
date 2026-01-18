import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import '../providers/post_provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  Player? _selectedPlayer;
  String _mediaType = 'photo';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerProvider>().loadAllPlayers();
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _selectPlayer() async {
    final players = context.read<PlayerProvider>().allPlayers;
    final selected = await showModalBottomSheet<Player>(
      context: context,
      builder: (context) {
        return ListView(
          children: players
              .map(
                (player) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(player.photoUrl),
                  ),
                  title: Text(player.name),
                  subtitle: Text(player.positionsDisplay),
                  onTap: () => Navigator.pop(context, player),
                ),
              )
              .toList(),
        );
      },
    );
    if (selected != null) {
      setState(() {
        _selectedPlayer = selected;
      });
    }
  }

  Future<void> _publish() async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      _showLoginPrompt(context);
      return;
    }

    if (_selectedPlayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um jogador.')),
      );
      return;
    }

    final post = Post(
      id: const Uuid().v4(),
      authorId: authProvider.currentUserId!,
      linkedPlayerId: _selectedPlayer!.id,
      mediaType: _mediaType,
      mediaUrl:
          'https://via.placeholder.com/300x500/1E40AF/FFFFFF?text=Nova+Publicacao',
      caption: _captionController.text.trim(),
      tags: ['nova', 'futly'],
      createdAt: DateTime.now(),
      likes: 0,
      comments: 0,
      reposts: 0,
      likedByUsers: [],
      savedByUsers: [],
      repostedByUsers: [],
    );

    await context.read<PostProvider>().createPost(post);

    if (mounted) {
      _captionController.clear();
      setState(() {
        _selectedPlayer = null;
        _mediaType = 'photo';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicação criada com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 12),
              const Text('Faça login para criar uma publicação.'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova publicação'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _mediaType,
            decoration: const InputDecoration(labelText: 'Tipo de mídia'),
            items: const [
              DropdownMenuItem(value: 'photo', child: Text('Foto')),
              DropdownMenuItem(value: 'video', child: Text('Vídeo')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _mediaType = value);
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _captionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Legenda',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              _selectedPlayer == null
                  ? 'Selecionar jogador'
                  : _selectedPlayer!.name,
            ),
            subtitle: Text(
              _selectedPlayer == null
                  ? 'Vincule um atleta à publicação'
                  : _selectedPlayer!.positionsDisplay,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _selectPlayer,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _publish,
            child: const Text('Publicar agora'),
          ),
        ],
      ),
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
