import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/post_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({required this.postId, super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadFeedPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    if (postProvider.feedPosts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Post'),
        ),
        body: const Center(child: Text('Post não encontrado')),
      );
    }

    final post = postProvider.feedPosts.firstWhere(
      (p) => p.id == widget.postId,
      orElse: () => postProvider.feedPosts.first,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Post'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(
            post.mediaUrl,
            height: 320,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          Text(post.caption ?? 'Sem legenda'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${post.likes} curtidas'),
              Text('${post.comments} comentários'),
              Text('${post.reposts} reposts'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push('/home/post/${post.id}/comments'),
            icon: const Icon(Icons.mode_comment_outlined),
            label: const Text('Ver comentários'),
          ),
        ],
      ),
    );
  }
}
