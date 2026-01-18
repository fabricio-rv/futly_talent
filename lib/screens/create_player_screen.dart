import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';

class CreatePlayerScreen extends StatefulWidget {
  const CreatePlayerScreen({super.key});

  @override
  State<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _clubController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();

  int _currentStep = 0;
  PlayerPosition _position = PlayerPosition.st;
  Foot _preferredFoot = Foot.right;

  @override
  void dispose() {
    _nameController.dispose();
    _clubController.dispose();
    _countryController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  Future<void> _createPlayer() async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      _showLoginPrompt(context);
      return;
    }

    final birthYear = int.tryParse(_birthYearController.text) ?? 2002;
    final age = DateTime.now().year - birthYear;
    final height = double.tryParse(_heightController.text) ?? 180;
    final weight = double.tryParse(_weightController.text) ?? 75;

    final player = Player(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      birthYear: birthYear,
      age: age,
      nationality: _countryController.text.trim().isEmpty
          ? 'Brasil'
          : _countryController.text.trim(),
      club: _clubController.text.trim().isEmpty
          ? 'Sem clube'
          : _clubController.text.trim(),
      league: 'Comunidade',
      country: _countryController.text.trim().isEmpty
          ? 'Brasil'
          : _countryController.text.trim(),
      contractStatus: ContractStatus.noInfo,
      status: PlayerStatus.base,
      positions: [_position],
      primaryPosition: _position,
      height: height,
      weight: weight,
      bodyType: BodyType.athletic,
      preferredFoot: _preferredFoot,
      isVerified: false,
      createdByUserId: authProvider.currentUserId,
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
      styleTags: const ['Comunidade'],
      roles: const ['Em avaliação'],
      strengths: const ['Potencial'],
      weaknesses: const ['Inconsistente'],
      bestSystems: const ['4-3-3'],
      bestBlock: TacticalBlock.medium,
      description: 'Jogador criado pela comunidade. Em avaliação.',
      estimatedValueMin: 200000,
      estimatedValueMax: 800000,
      potential: Potential.medium,
      transferRisk: TransferRisk.medium,
      isReadyToLevelUp: false,
      injuryHistory: const [],
      injuryRisk: InjuryRisk.low,
      photoUrl:
          'https://via.placeholder.com/200/1E40AF/FFFFFF?text=Novo+Jogador',
      highlightVideos: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      followers: 0,
      savedByUsers: const [],
    );

    await context.read<PlayerProvider>().createPlayer(player);

    if (mounted) {
      _showSuccessModal(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Criar jogador'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            _createPlayer();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: [
          Step(
            title: const Text('Dados básicos'),
            content: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _birthYearController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Ano de nascimento'),
                ),
                TextField(
                  controller: _countryController,
                  decoration: const InputDecoration(labelText: 'País'),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Clubes e posições'),
            content: Column(
              children: [
                TextField(
                  controller: _clubController,
                  decoration: const InputDecoration(labelText: 'Clube'),
                ),
                DropdownButtonFormField<PlayerPosition>(
                  initialValue: _position,
                  decoration: const InputDecoration(labelText: 'Posição'),
                  items: PlayerPosition.values
                      .map(
                        (position) => DropdownMenuItem(
                          value: position,
                          child: Text(position.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _position = value);
                    }
                  },
                ),
                DropdownButtonFormField<Foot>(
                  initialValue: _preferredFoot,
                  decoration: const InputDecoration(labelText: 'Pé preferido'),
                  items: Foot.values
                      .map(
                        (foot) => DropdownMenuItem(
                          value: foot,
                          child: Text(_footLabel(foot)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _preferredFoot = value);
                    }
                  },
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Dados físicos'),
            content: Column(
              children: [
                TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Altura (cm)'),
                ),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showSuccessModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jogador criado com sucesso!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Ok, voltar'),
            ),
          ),
        ],
      ),
    ),
  );
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
