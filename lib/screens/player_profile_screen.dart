import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class PlayerProfileScreen extends StatefulWidget {
  final String playerId;

  const PlayerProfileScreen({required this.playerId, super.key});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerProvider>().loadPlayerById(widget.playerId);
    });
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

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final postProvider = context.read<PostProvider>();
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    final player = playerProvider.selectedPlayer;

    if (playerProvider.isLoading || player == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final notes = authProvider.isAuthenticated
        ? userProvider.getPrivateNote(
            authProvider.currentUserId!,
            player.id,
          )
        : '';

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(player.name),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Visão Geral'),
              Tab(text: 'Análise'),
              Tab(text: 'Onde rende mais'),
              Tab(text: 'Evolução'),
              Tab(text: 'Conteúdos'),
              Tab(text: 'Notas privadas'),
              Tab(text: 'Risco'),
              Tab(text: 'Mercado'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OverviewTab(player: player),
            _AnalysisTab(player: player),
            _BestFitTab(player: player),
            _EvolutionTab(player: player),
            _ContentTab(
              player: player,
              postProvider: postProvider,
            ),
            _PrivateNotesTab(
              initialNotes: notes,
              canEdit: authProvider.isAuthenticated,
              onSave: (value) {
                if (!authProvider.isAuthenticated) {
                  _showLoginPrompt(context);
                  return;
                }
                userProvider.setPrivateNote(
                  authProvider.currentUserId!,
                  player.id,
                  value,
                );
              },
            ),
            _RiskTab(player: player),
            _MarketTab(player: player),
          ],
        ),
        bottomNavigationBar: _PlayerActions(
          player: player,
          authProvider: authProvider,
          onFavorite: () {
            if (!authProvider.isAuthenticated) {
              _showLoginPrompt(context);
              return;
            }
            context.read<PlayerProvider>().favoritePlayer(
                  player.id,
                  authProvider.currentUserId!,
                );
          },
          onCompare: () => context.push('/home/compare'),
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Link do jogador copiado!')),
            );
          },
        ),
      ),
    );
  }
}

class _PlayerActions extends StatelessWidget {
  final Player player;
  final AuthProvider authProvider;
  final VoidCallback onFavorite;
  final VoidCallback onCompare;
  final VoidCallback onShare;

  const _PlayerActions({
    required this.player,
    required this.authProvider,
    required this.onFavorite,
    required this.onCompare,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onFavorite,
                icon: const Icon(Icons.favorite_border),
                label: const Text('Favoritar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCompare,
                icon: const Icon(Icons.compare_arrows),
                label: const Text('Comparar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share),
                label: const Text('Compartilhar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Player player;

  const _OverviewTab({required this.player});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(player.photoUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          player.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (player.isVerified)
                        const Icon(Icons.verified, color: Colors.blue),
                    ],
                  ),
                  Text('${player.age} anos • ${player.nationality}'),
                  Text('${player.club} • ${player.league}'),
                  Text(
                    'Posições: ${player.positionsDisplay}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Pé preferido: ${_footLabel(player.preferredFoot)}',
                  ),
                  Text('Altura: ${player.height} cm • ${player.weight} kg'),
                  if (player.createdByUserId != null)
                    Text('Criado por @${player.createdByUserId}'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Resumo editorial',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(player.description),
        const SizedBox(height: 16),
        Text('Tags-chave', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              player.styleTags.map((tag) => Chip(label: Text(tag))).toList(),
        ),
      ],
    );
  }
}

class _AnalysisTab extends StatelessWidget {
  final Player player;

  const _AnalysisTab({required this.player});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Avaliação interna',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _RatingRow(label: 'Aceleração', value: player.paceAcceleration),
        _RatingRow(label: 'Velocidade', value: player.topSpeed),
        _RatingRow(label: 'Passe curto', value: player.passingShort),
        _RatingRow(label: 'Passe longo', value: player.passingLong),
        _RatingRow(label: 'Finalização', value: player.finishing),
        _RatingRow(label: 'Drible', value: player.dribbling),
        _RatingRow(label: 'Tackling', value: player.tackling),
        _RatingRow(label: 'Visão de jogo', value: player.gameIQ),
        _RatingRow(label: 'Composição', value: player.composure),
      ],
    );
  }
}

class _BestFitTab extends StatelessWidget {
  final Player player;

  const _BestFitTab({required this.player});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Melhores sistemas',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: player.bestSystems
              .map((system) => Chip(label: Text(system)))
              .toList(),
        ),
        const SizedBox(height: 16),
        Text('Bloco ideal', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Chip(label: Text(_blockLabel(player.bestBlock))),
        const SizedBox(height: 16),
        Text('Função em destaque',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              player.roles.map((role) => Chip(label: Text(role))).toList(),
        ),
      ],
    );
  }
}

class _EvolutionTab extends StatelessWidget {
  final Player player;

  const _EvolutionTab({required this.player});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Linha do tempo', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.timeline),
          title: const Text('Evolução física'),
          subtitle: Text(
            'Aumento de força e resistência nos últimos 12 meses.',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.timeline),
          title: const Text('Consistência técnica'),
          subtitle: Text(
            'Melhoria na tomada de decisão e no passe curto.',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.timeline),
          title: const Text('Maturidade mental'),
          subtitle: Text(
            'Maior liderança e equilíbrio emocional em jogos grandes.',
          ),
        ),
      ],
    );
  }
}

class _ContentTab extends StatelessWidget {
  final Player player;
  final PostProvider postProvider;

  const _ContentTab({required this.player, required this.postProvider});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: postProvider.getPlayerPosts(player.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return const Center(child: Text('Nenhum conteúdo encontrado.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              child: ListTile(
                onTap: () => context.push('/home/post/${post.id}'),
                leading: Image.network(
                  post.mediaUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
                title: Text(post.caption ?? 'Post sem legenda'),
                subtitle: Text('${post.likes} curtidas'),
              ),
            );
          },
        );
      },
    );
  }
}

class _PrivateNotesTab extends StatefulWidget {
  final String initialNotes;
  final bool canEdit;
  final ValueChanged<String> onSave;

  const _PrivateNotesTab({
    required this.initialNotes,
    required this.canEdit,
    required this.onSave,
  });

  @override
  State<_PrivateNotesTab> createState() => _PrivateNotesTabState();
}

class _PrivateNotesTabState extends State<_PrivateNotesTab> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notas privadas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (!widget.canEdit)
            const Text('Faça login para registrar suas observações.'),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 6,
            enabled: widget.canEdit,
            decoration: const InputDecoration(
              hintText: 'Digite observações internas sobre o atleta...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: widget.canEdit
                ? () {
                    widget.onSave(_controller.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notas salvas!')),
                    );
                  }
                : null,
            child: const Text('Salvar notas'),
          ),
        ],
      ),
    );
  }
}

class _RiskTab extends StatelessWidget {
  final Player player;

  const _RiskTab({required this.player});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Risco físico', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Chip(label: Text(_riskLabel(player.injuryRisk))),
        const SizedBox(height: 16),
        Text('Dependência de sistema',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('Melhor desempenho em sistemas que favorecem transições.'),
        const SizedBox(height: 16),
        Text('Disciplina', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('Disciplina: ${player.discipline}/100'),
      ],
    );
  }
}

class _MarketTab extends StatelessWidget {
  final Player player;

  const _MarketTab({required this.player});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Faixa de mercado',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          '€ ${player.estimatedValueMin} - € ${player.estimatedValueMax}',
        ),
        const SizedBox(height: 16),
        Text('Potencial', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Chip(label: Text(_potentialLabel(player.potential))),
        const SizedBox(height: 16),
        Text('Pronto para subir nível?',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(player.isReadyToLevelUp ? 'Sim' : 'Ainda em evolução'),
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final int value;

  const _RatingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(value.toString()),
        ],
      ),
    );
  }
}

String _footLabel(Foot foot) {
  switch (foot) {
    case Foot.right:
      return 'Direito';
    case Foot.left:
      return 'Esquerdo';
    case Foot.both:
      return 'Ambidestro';
  }
}

String _riskLabel(InjuryRisk risk) {
  switch (risk) {
    case InjuryRisk.low:
      return 'Baixo';
    case InjuryRisk.medium:
      return 'Médio';
    case InjuryRisk.high:
      return 'Alto';
  }
}

String _potentialLabel(Potential potential) {
  switch (potential) {
    case Potential.low:
      return 'Baixo';
    case Potential.medium:
      return 'Médio';
    case Potential.high:
      return 'Alto';
  }
}

String _blockLabel(TacticalBlock block) {
  switch (block) {
    case TacticalBlock.high:
      return 'Bloco alto';
    case TacticalBlock.medium:
      return 'Bloco médio';
    case TacticalBlock.low:
      return 'Bloco baixo';
  }
}
