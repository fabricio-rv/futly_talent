import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../providers/player_provider.dart';
import '../providers/user_provider.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Player? _playerA;
  Player? _playerB;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerProvider>().loadAllPlayers();
    });
  }

  Future<void> _selectPlayer(bool isA) async {
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
        if (isA) {
          _playerA = selected;
        } else {
          _playerB = selected;
        }
      });
    }
  }

  void _saveComparison() {
    if (_playerA == null || _playerB == null) return;
    final comparison = Comparison(
      id: const Uuid().v4(),
      player1Id: _playerA!.id,
      player2Id: _playerB!.id,
      createdAt: DateTime.now(),
    );
    context.read<UserProvider>().saveComparison(comparison);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comparação salva no histórico.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _PlayerSelectCard(
                  label: 'Jogador A',
                  player: _playerA,
                  onTap: () => _selectPlayer(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PlayerSelectCard(
                  label: 'Jogador B',
                  player: _playerB,
                  onTap: () => _selectPlayer(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                _playerA != null && _playerB != null ? _saveComparison : null,
            child: const Text('Salvar comparação'),
          ),
          const SizedBox(height: 24),
          if (_playerA != null && _playerB != null) ...[
            Text('Resumo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'A comparação destaca ${_playerA!.styleTags.first} versus ${_playerB!.styleTags.first}. ',
            ),
            const SizedBox(height: 16),
            _ComparisonRow(
              label: 'Aceleração',
              valueA: _playerA!.paceAcceleration,
              valueB: _playerB!.paceAcceleration,
            ),
            _ComparisonRow(
              label: 'Passe curto',
              valueA: _playerA!.passingShort,
              valueB: _playerB!.passingShort,
            ),
            _ComparisonRow(
              label: 'Finalização',
              valueA: _playerA!.finishing,
              valueB: _playerB!.finishing,
            ),
            _ComparisonRow(
              label: 'Tackling',
              valueA: _playerA!.tackling,
              valueB: _playerB!.tackling,
            ),
            _ComparisonRow(
              label: 'Composição',
              valueA: _playerA!.composure,
              valueB: _playerB!.composure,
            ),
          ],
        ],
      ),
    );
  }
}

class _PlayerSelectCard extends StatelessWidget {
  final String label;
  final Player? player;
  final VoidCallback onTap;

  const _PlayerSelectCard({
    required this.label,
    required this.player,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (player == null)
              const Text('Selecionar')
            else
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(player!.photoUrl),
                    radius: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(player!.name, textAlign: TextAlign.center),
                  Text(player!.positionsDisplay,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final int valueA;
  final int valueB;

  const _ComparisonRow({
    required this.label,
    required this.valueA,
    required this.valueB,
  });

  @override
  Widget build(BuildContext context) {
    final total = valueA + valueB;
    final aPercent = total == 0 ? 0.5 : valueA / total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                flex: (aPercent * 100).round(),
                child: Container(height: 10, color: Colors.blue),
              ),
              Expanded(
                flex: ((1 - aPercent) * 100).round(),
                child: Container(height: 10, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(valueA.toString()),
              Text(valueB.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
