import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({required this.postId, super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPostComments(widget.postId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      _showLoginPrompt(context);
      return;
    }

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await context.read<PostProvider>().addComment(
          widget.postId,
          authProvider.currentUserId!,
          text,
        );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Comentários'),
      ),
      body: Column(
        children: [
          Expanded(
            child: postProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: postProvider.postComments.length,
                    itemBuilder: (context, index) {
                      final comment = postProvider.postComments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            comment.authorId.isNotEmpty
                                ? comment.authorId[0]
                                : '?',
                          ),
                        ),
                        title: Text(comment.text),
                        subtitle: Text('${comment.likes} curtidas'),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Adicionar comentário...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
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
