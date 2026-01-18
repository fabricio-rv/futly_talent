import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

class SuggestionFormScreen extends StatefulWidget {
  const SuggestionFormScreen({super.key});

  @override
  State<SuggestionFormScreen> createState() => _SuggestionFormScreenState();
}

class _SuggestionFormScreenState extends State<SuggestionFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _clubController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  PlayerPosition _position = PlayerPosition.cm;

  @override
  void dispose() {
    _nameController.dispose();
    _clubController.dispose();
    _countryController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      _showLoginPrompt(context);
      return;
    }

    final suggestion = PlayerSuggestion(
      id: const Uuid().v4(),
      suggestedByUserId: authProvider.currentUserId!,
      name: _nameController.text.trim(),
      position: _position,
      club: _clubController.text.trim(),
      country: _countryController.text.trim(),
      reason: _reasonController.text.trim(),
      suggestedTags: const ['Potencial', 'Observação'],
      suggestedStrengths: const ['Agilidade', 'Passe'],
      suggestedWeaknesses: const ['Consistência'],
      estimatedValueMin: 200000,
      estimatedValueMax: 800000,
      createdAt: DateTime.now(),
      status: 'pending',
    );

    await context.read<UserProvider>().createSuggestion(suggestion);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sugestão enviada!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Nova sugestão'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome do jogador'),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 12),
          TextField(
            controller: _clubController,
            decoration: const InputDecoration(labelText: 'Clube'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _countryController,
            decoration: const InputDecoration(labelText: 'País'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Motivo da sugestão',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Enviar sugestão'),
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
