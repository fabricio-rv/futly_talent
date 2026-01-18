import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/player_provider.dart';
import 'providers/post_provider.dart';
import 'providers/user_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/main_screen.dart';
import 'screens/search_screen.dart';
import 'screens/player_profile_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/comments_screen.dart';
import 'screens/compare_screen.dart';
import 'screens/create_post_screen.dart';
import 'screens/dm_list_screen.dart';
import 'screens/dm_chat_screen.dart';
import 'screens/user_settings_screen.dart';
import 'screens/create_player_screen.dart';
import 'screens/verification_request_screen.dart';
import 'screens/suggestion_form_screen.dart';
import 'screens/suggestions_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FutlyTalentApp());
}

class FutlyTalentApp extends StatelessWidget {
  const FutlyTalentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final router = _buildRouter(authProvider);

          return MaterialApp.router(
            title: 'Futly Talent',
            theme: AppTheme.lightTheme,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  GoRouter _buildRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainScreen(),
          routes: [
            GoRoute(
              path: 'search',
              builder: (context, state) => const SearchScreen(),
            ),
            GoRoute(
              path: 'player/:id',
              builder: (context, state) {
                final playerId = state.pathParameters['id']!;
                return PlayerProfileScreen(playerId: playerId);
              },
            ),
            GoRoute(
              path: 'post/:id',
              builder: (context, state) {
                final postId = state.pathParameters['id']!;
                return PostDetailScreen(postId: postId);
              },
            ),
            GoRoute(
              path: 'post/:id/comments',
              builder: (context, state) {
                final postId = state.pathParameters['id']!;
                return CommentsScreen(postId: postId);
              },
            ),
            GoRoute(
              path: 'compare',
              builder: (context, state) => const CompareScreen(),
            ),
            GoRoute(
              path: 'create-post',
              builder: (context, state) => const CreatePostScreen(),
            ),
            GoRoute(
              path: 'dm',
              builder: (context, state) => const DmListScreen(),
              routes: [
                GoRoute(
                  path: ':userId',
                  builder: (context, state) {
                    final userId = state.pathParameters['userId']!;
                    return DmChatScreen(userId: userId);
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const UserSettingsScreen(),
            ),
            GoRoute(
              path: 'create-player',
              builder: (context, state) => const CreatePlayerScreen(),
            ),
            GoRoute(
              path: 'verification-request',
              builder: (context, state) => const VerificationRequestScreen(),
            ),
            GoRoute(
              path: 'suggestions/new',
              builder: (context, state) => const SuggestionFormScreen(),
            ),
            GoRoute(
              path: 'suggestions/list',
              builder: (context, state) => const SuggestionsListScreen(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isOnWelcome = state.matchedLocation == '/welcome';

        if (isLoggedIn && isOnWelcome) {
          return '/home';
        }

        return null;
      },
    );
  }
}
