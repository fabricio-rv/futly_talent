import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import '../providers/post_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.mail_outline),
          onPressed: () => context.push('/home/dm'),
        ),
        title: const Text('Futly Talent'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/home/search'),
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, _) {
          if (postProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postProvider.feedPosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.post_add, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma publicação ainda',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: postProvider.feedPosts.length,
            itemBuilder: (context, index) {
              final post = postProvider.feedPosts[index];
              return PostCardWidget(post: post, authProvider: authProvider);
            },
          );
        },
      ),
    );
  }
}

class PostCardWidget extends StatelessWidget {
  final Post post;
  final AuthProvider authProvider;

  const PostCardWidget({
    required this.post,
    required this.authProvider,
    super.key,
  });

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
    final postProvider = context.watch<PostProvider>();
    final playerProvider = context.watch<PlayerProvider>();

    final isLiked = authProvider.isAuthenticated &&
        postProvider.isPostLiked(post.id, authProvider.currentUserId!);
    final isSaved = authProvider.isAuthenticated &&
        postProvider.isPostSaved(post.id, authProvider.currentUserId!);
    final isReposted = authProvider.isAuthenticated &&
        postProvider.isPostReposted(post.id, authProvider.currentUserId!);

    final player = playerProvider.allPlayers.firstWhere(
      (p) => p.id == post.linkedPlayerId,
      orElse: () => Player(
        id: 'player_unknown',
        name: 'Jogador',
        birthYear: 2000,
        age: 24,
        nationality: 'Brasil',
        club: 'Clube',
        league: 'Liga',
        country: 'Brasil',
        contractStatus: ContractStatus.noInfo,
        status: PlayerStatus.withoutClub,
        positions: const [PlayerPosition.cm],
        primaryPosition: PlayerPosition.cm,
        height: 180,
        weight: 75,
        bodyType: BodyType.athletic,
        preferredFoot: Foot.right,
        isVerified: false,
        paceAcceleration: 60,
        topSpeed: 60,
        stamina: 60,
        strength: 60,
        agility: 60,
        balance: 60,
        jump: 60,
        passingShort: 60,
        passingLong: 60,
        progressivePass: 60,
        firstTouch: 60,
        ballControl: 60,
        dribbling: 60,
        crossing: 60,
        finishing: 60,
        shotPower: 60,
        heading: 60,
        tackling: 60,
        interception: 60,
        positioning: 60,
        aerialDuels: 60,
        groundDuels: 60,
        weakFootQuality: 60,
        buildUp: 60,
        pressResistance: 60,
        decisionMaking: 60,
        scanning: 60,
        offBallMovement: 60,
        defensiveLine: 60,
        pressing: 60,
        recoveryRuns: 60,
        composure: 60,
        aggression: 60,
        leadership: 60,
        teamwork: 60,
        resilience: 60,
        coachability: 60,
        professionalism: 60,
        gameIQ: 60,
        riskTaking: 60,
        discipline: 60,
        styleTags: const ['Completo'],
        roles: const ['Meia'],
        strengths: const ['Passe'],
        weaknesses: const ['Regularidade'],
        bestSystems: const ['4-3-3'],
        bestBlock: TacticalBlock.medium,
        description: 'Perfil padrão para exibição.',
        estimatedValueMin: 500000,
        estimatedValueMax: 1000000,
        potential: Potential.medium,
        transferRisk: TransferRisk.medium,
        isReadyToLevelUp: false,
        injuryHistory: const [],
        injuryRisk: InjuryRisk.low,
        photoUrl: 'https://via.placeholder.com/200/94A3B8/FFFFFF?text=Player',
        highlightVideos: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        followers: 0,
        savedByUsers: const [],
      ),
    );

    return GestureDetector(
      onTap: () => context.push('/home/post/${post.id}'),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/home/player/${player.id}'),
                    child: Text(player.name),
                  ),
                  if (player.isVerified)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.verified, size: 16, color: Colors.blue),
                    ),
                ],
              ),
              subtitle: Text('${player.club} • ${player.league}'),
            ),
            Container(
              height: 280,
              width: double.infinity,
              color: Colors.black12,
              child: Image.network(
                post.mediaUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Center(
                    child: Icon(Icons.play_circle, size: 48),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                post.caption ?? 'Sem legenda',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.favorite,
                    label: post.likes.toString(),
                    color: isLiked ? AppTheme.accentColor : null,
                    onTap: () {
                      if (!authProvider.isAuthenticated) {
                        _showLoginPrompt(context);
                        return;
                      }
                      if (isLiked) {
                        postProvider.unlikePost(
                          post.id,
                          authProvider.currentUserId!,
                        );
                      } else {
                        postProvider.likePost(
                          post.id,
                          authProvider.currentUserId!,
                        );
                      }
                    },
                  ),
                  _ActionButton(
                    icon: Icons.mode_comment_outlined,
                    label: post.comments.toString(),
                    onTap: () => context.push('/home/post/${post.id}/comments'),
                  ),
                  _ActionButton(
                    icon: Icons.repeat,
                    label: post.reposts.toString(),
                    color: isReposted ? AppTheme.secondaryColor : null,
                    onTap: () {
                      if (!authProvider.isAuthenticated) {
                        _showLoginPrompt(context);
                        return;
                      }
                      if (isReposted) {
                        postProvider.unrepostPost(
                          post.id,
                          authProvider.currentUserId!,
                        );
                      } else {
                        postProvider.repostPost(
                          post.id,
                          authProvider.currentUserId!,
                        );
                      }
                    },
                  ),
                  _ActionButton(
                    icon: Icons.bookmark,
                    label: '',
                    color: isSaved ? AppTheme.primaryColor : null,
                    onTap: () {
                      if (!authProvider.isAuthenticated) {
                        _showLoginPrompt(context);
                        return;
                      }
                      if (isSaved) {
                        postProvider.unsavePost(
                          post.id,
                          authProvider.currentUserId!,
                        );
                      } else {
                        postProvider.savePost(
                          post.id,
                          authProvider.currentUserId!,
                        );
                      }
                    },
                  ),
                  _ActionButton(
                    icon: Icons.share,
                    label: '',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link copiado para compartilhar!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.grey[700]),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(label),
            ],
          ],
        ),
      ),
    );
  }
}
