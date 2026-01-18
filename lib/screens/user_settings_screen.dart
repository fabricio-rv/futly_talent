import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Preferências de notificações'),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Privacidade'),
          ),
          ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Tema'),
          ),
        ],
      ),
    );
  }
}
