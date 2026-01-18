import '../models/models.dart';
import 'mock_data_service.dart';

class PostRepository {
  final List<Post> _posts = MockDataService.generateMockPosts();
  final List<Comment> _comments = MockDataService.generateMockComments();

  Future<List<Post>> getFeedPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _posts;
  }

  Future<Post?> getPostById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> likePost(String postId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      if (!post.likedByUsers.contains(userId)) {
        _posts[postIndex] = Post(
          id: post.id,
          authorId: post.authorId,
          linkedPlayerId: post.linkedPlayerId,
          mediaType: post.mediaType,
          mediaUrl: post.mediaUrl,
          caption: post.caption,
          tags: post.tags,
          createdAt: post.createdAt,
          likes: post.likes + 1,
          comments: post.comments,
          reposts: post.reposts,
          likedByUsers: [...post.likedByUsers, userId],
          savedByUsers: post.savedByUsers,
          repostedByUsers: post.repostedByUsers,
        );
      }
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      if (post.likedByUsers.contains(userId)) {
        _posts[postIndex] = Post(
          id: post.id,
          authorId: post.authorId,
          linkedPlayerId: post.linkedPlayerId,
          mediaType: post.mediaType,
          mediaUrl: post.mediaUrl,
          caption: post.caption,
          tags: post.tags,
          createdAt: post.createdAt,
          likes: post.likes - 1,
          comments: post.comments,
          reposts: post.reposts,
          likedByUsers: post.likedByUsers.where((id) => id != userId).toList(),
          savedByUsers: post.savedByUsers,
          repostedByUsers: post.repostedByUsers,
        );
      }
    }
  }

  Future<void> savePost(String postId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      if (!post.savedByUsers.contains(userId)) {
        _posts[postIndex] = Post(
          id: post.id,
          authorId: post.authorId,
          linkedPlayerId: post.linkedPlayerId,
          mediaType: post.mediaType,
          mediaUrl: post.mediaUrl,
          caption: post.caption,
          tags: post.tags,
          createdAt: post.createdAt,
          likes: post.likes,
          comments: post.comments,
          reposts: post.reposts,
          likedByUsers: post.likedByUsers,
          savedByUsers: [...post.savedByUsers, userId],
          repostedByUsers: post.repostedByUsers,
        );
      }
    }
  }

  Future<void> unsavePost(String postId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = Post(
        id: post.id,
        authorId: post.authorId,
        linkedPlayerId: post.linkedPlayerId,
        mediaType: post.mediaType,
        mediaUrl: post.mediaUrl,
        caption: post.caption,
        tags: post.tags,
        createdAt: post.createdAt,
        likes: post.likes,
        comments: post.comments,
        reposts: post.reposts,
        likedByUsers: post.likedByUsers,
        savedByUsers: post.savedByUsers.where((id) => id != userId).toList(),
        repostedByUsers: post.repostedByUsers,
      );
    }
  }

  Future<void> repostPost(String postId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      if (!post.repostedByUsers.contains(userId)) {
        _posts[postIndex] = Post(
          id: post.id,
          authorId: post.authorId,
          linkedPlayerId: post.linkedPlayerId,
          mediaType: post.mediaType,
          mediaUrl: post.mediaUrl,
          caption: post.caption,
          tags: post.tags,
          createdAt: post.createdAt,
          likes: post.likes,
          comments: post.comments,
          reposts: post.reposts + 1,
          likedByUsers: post.likedByUsers,
          savedByUsers: post.savedByUsers,
          repostedByUsers: [...post.repostedByUsers, userId],
        );
      }
    }
  }

  Future<void> unrepostPost(String postId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = Post(
        id: post.id,
        authorId: post.authorId,
        linkedPlayerId: post.linkedPlayerId,
        mediaType: post.mediaType,
        mediaUrl: post.mediaUrl,
        caption: post.caption,
        tags: post.tags,
        createdAt: post.createdAt,
        likes: post.likes,
        comments: post.comments,
        reposts: post.reposts - 1,
        likedByUsers: post.likedByUsers,
        savedByUsers: post.savedByUsers,
        repostedByUsers:
            post.repostedByUsers.where((id) => id != userId).toList(),
      );
    }
  }

  Future<void> createPost(Post post) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _posts.insert(0, post); // Add to beginning (newest first)
  }

  // Comments
  Future<List<Comment>> getPostComments(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _comments.where((c) => c.postId == postId).toList();
  }

  Future<void> addComment(Comment comment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _comments.add(comment);

    // Update comment count
    final postIndex = _posts.indexWhere((p) => p.id == comment.postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = Post(
        id: post.id,
        authorId: post.authorId,
        linkedPlayerId: post.linkedPlayerId,
        mediaType: post.mediaType,
        mediaUrl: post.mediaUrl,
        caption: post.caption,
        tags: post.tags,
        createdAt: post.createdAt,
        likes: post.likes,
        comments: post.comments + 1,
        reposts: post.reposts,
        likedByUsers: post.likedByUsers,
        savedByUsers: post.savedByUsers,
        repostedByUsers: post.repostedByUsers,
      );
    }
  }

  Future<void> likeComment(String commentId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final commentIndex = _comments.indexWhere((c) => c.id == commentId);
    if (commentIndex != -1) {
      final comment = _comments[commentIndex];
      if (!comment.likedByUsers.contains(userId)) {
        _comments[commentIndex] = Comment(
          id: comment.id,
          postId: comment.postId,
          authorId: comment.authorId,
          text: comment.text,
          createdAt: comment.createdAt,
          likes: comment.likes + 1,
          likedByUsers: [...comment.likedByUsers, userId],
        );
      }
    }
  }

  Future<List<Post>> getPlayerPosts(String playerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _posts.where((p) => p.linkedPlayerId == playerId).toList();
  }

  Future<List<Post>> getSavedPosts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _posts.where((p) => p.savedByUsers.contains(userId)).toList();
  }
}
