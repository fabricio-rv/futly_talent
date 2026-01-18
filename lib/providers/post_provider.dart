import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../services/post_repository.dart';
import '../models/models.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repository = PostRepository();

  List<Post> _feedPosts = [];
  List<Comment> _postComments = [];
  bool _isLoading = false;

  List<Post> get feedPosts => _feedPosts;
  List<Comment> get postComments => _postComments;
  bool get isLoading => _isLoading;

  Future<void> loadFeedPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _feedPosts = await _repository.getFeedPosts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      await _repository.likePost(postId, userId);

      final postIndex = _feedPosts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _feedPosts[postIndex];
        _feedPosts[postIndex] = Post(
          id: post.id,
          authorId: post.authorId,
          linkedPlayerId: post.linkedPlayerId,
          mediaType: post.mediaType,
          mediaUrl: post.mediaUrl,
          caption: post.caption,
          tags: post.tags,
          createdAt: post.createdAt,
          likes: post.likes + (post.likedByUsers.contains(userId) ? 0 : 1),
          comments: post.comments,
          reposts: post.reposts,
          likedByUsers: post.likedByUsers.contains(userId)
              ? post.likedByUsers
              : [...post.likedByUsers, userId],
          savedByUsers: post.savedByUsers,
          repostedByUsers: post.repostedByUsers,
        );
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _repository.unlikePost(postId, userId);

      final postIndex = _feedPosts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _feedPosts[postIndex];
        _feedPosts[postIndex] = Post(
          id: post.id,
          authorId: post.authorId,
          linkedPlayerId: post.linkedPlayerId,
          mediaType: post.mediaType,
          mediaUrl: post.mediaUrl,
          caption: post.caption,
          tags: post.tags,
          createdAt: post.createdAt,
          likes: post.likes - (post.likedByUsers.contains(userId) ? 1 : 0),
          comments: post.comments,
          reposts: post.reposts,
          likedByUsers: post.likedByUsers.where((id) => id != userId).toList(),
          savedByUsers: post.savedByUsers,
          repostedByUsers: post.repostedByUsers,
        );
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> savePost(String postId, String userId) async {
    try {
      await _repository.savePost(postId, userId);
      final postIndex = _feedPosts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _feedPosts[postIndex];
        if (!post.savedByUsers.contains(userId)) {
          _feedPosts[postIndex] = Post(
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
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unsavePost(String postId, String userId) async {
    try {
      await _repository.unsavePost(postId, userId);
      final postIndex = _feedPosts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _feedPosts[postIndex];
        _feedPosts[postIndex] = Post(
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
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> repostPost(String postId, String userId) async {
    try {
      await _repository.repostPost(postId, userId);

      final postIndex = _feedPosts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _feedPosts[postIndex];
        _feedPosts[postIndex] = Post(
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
          reposts:
              post.reposts + (post.repostedByUsers.contains(userId) ? 0 : 1),
          likedByUsers: post.likedByUsers,
          savedByUsers: post.savedByUsers,
          repostedByUsers: post.repostedByUsers.contains(userId)
              ? post.repostedByUsers
              : [...post.repostedByUsers, userId],
        );
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unrepostPost(String postId, String userId) async {
    try {
      await _repository.unrepostPost(postId, userId);

      final postIndex = _feedPosts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _feedPosts[postIndex];
        _feedPosts[postIndex] = Post(
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
          reposts:
              post.reposts - (post.repostedByUsers.contains(userId) ? 1 : 0),
          likedByUsers: post.likedByUsers,
          savedByUsers: post.savedByUsers,
          repostedByUsers:
              post.repostedByUsers.where((id) => id != userId).toList(),
        );
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadPostComments(String postId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _postComments = await _repository.getPostComments(postId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addComment(String postId, String authorId, String text) async {
    try {
      final comment = Comment(
        id: const Uuid().v4(),
        postId: postId,
        authorId: authorId,
        text: text,
        createdAt: DateTime.now(),
        likes: 0,
        likedByUsers: [],
      );

      await _repository.addComment(comment);
      _postComments.add(comment);

      // Update post comment count
      final postIndex = _feedPosts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = _feedPosts[postIndex];
        _feedPosts[postIndex] = Post(
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

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likeComment(String commentId, String userId) async {
    try {
      await _repository.likeComment(commentId, userId);

      final commentIndex = _postComments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = _postComments[commentIndex];
        _postComments[commentIndex] = Comment(
          id: comment.id,
          postId: comment.postId,
          authorId: comment.authorId,
          text: comment.text,
          createdAt: comment.createdAt,
          likes:
              comment.likes + (comment.likedByUsers.contains(userId) ? 0 : 1),
          likedByUsers: comment.likedByUsers.contains(userId)
              ? comment.likedByUsers
              : [...comment.likedByUsers, userId],
        );
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPost(Post post) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createPost(post);
      _feedPosts.insert(0, post);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Post>> getPlayerPosts(String playerId) async {
    try {
      return await _repository.getPlayerPosts(playerId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Post>> getSavedPosts(String userId) async {
    try {
      return await _repository.getSavedPosts(userId);
    } catch (e) {
      rethrow;
    }
  }

  bool isPostLiked(String postId, String userId) {
    final post = _feedPosts.firstWhere(
      (p) => p.id == postId,
      orElse: () => _feedPosts.isNotEmpty
          ? _feedPosts.first
          : Post(
              id: '',
              authorId: '',
              mediaType: '',
              mediaUrl: '',
              tags: [],
              createdAt: DateTime.now(),
              likes: 0,
              comments: 0,
              reposts: 0,
              likedByUsers: [],
              savedByUsers: [],
              repostedByUsers: [],
            ),
    );
    return post.likedByUsers.contains(userId);
  }

  bool isPostSaved(String postId, String userId) {
    final post = _feedPosts.firstWhere(
      (p) => p.id == postId,
      orElse: () => _feedPosts.isNotEmpty
          ? _feedPosts.first
          : Post(
              id: '',
              authorId: '',
              mediaType: '',
              mediaUrl: '',
              tags: [],
              createdAt: DateTime.now(),
              likes: 0,
              comments: 0,
              reposts: 0,
              likedByUsers: [],
              savedByUsers: [],
              repostedByUsers: [],
            ),
    );
    return post.savedByUsers.contains(userId);
  }

  bool isPostReposted(String postId, String userId) {
    final post = _feedPosts.firstWhere(
      (p) => p.id == postId,
      orElse: () => _feedPosts.isNotEmpty
          ? _feedPosts.first
          : Post(
              id: '',
              authorId: '',
              mediaType: '',
              mediaUrl: '',
              tags: [],
              createdAt: DateTime.now(),
              likes: 0,
              comments: 0,
              reposts: 0,
              likedByUsers: [],
              savedByUsers: [],
              repostedByUsers: [],
            ),
    );
    return post.repostedByUsers.contains(userId);
  }
}
