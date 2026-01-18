# FUTLY TALENT - DEVELOPER QUICK REFERENCE

## Quick Navigation

### File Structure Overview
```
lib/
├── main.dart → App entry & routing
├── theme/app_theme.dart → Material 3 colors & styles
├── models/models.dart → All data models
├── services/
│   ├── mock_data_service.dart → Mock data generator
│   ├── player_repository.dart → Player data access
│   ├── post_repository.dart → Post data access
│   └── other_repositories.dart → User, notification, DM, etc.
├── providers/
│   ├── auth_provider.dart → Authentication
│   ├── player_provider.dart → Players state
│   ├── post_provider.dart → Posts state
│   └── user_provider.dart → Users/notifications/DMs
├── screens/
│   ├── welcome_screen.dart → Welcome/login/register
│   ├── login_screen.dart → Login form
│   ├── register_screen.dart → Registration form
│   ├── reset_password_screen.dart → Password reset
│   ├── main_screen.dart → Home feed & bottom nav
│   └── other_screens.dart → All other screens
├── widgets/ → Reusable components (ready to expand)
└── utils/utils.dart → Utility functions
```

---

## Common Tasks

### Add a New Screen

1. **Create screen file** in `lib/screens/`
```dart
class MyNewScreen extends StatelessWidget {
  const MyNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Screen'),
      ),
      body: const Center(child: Text('Content here')),
    );
  }
}
```

2. **Add route** in `main.dart` under GoRouter configuration
```dart
GoRoute(
  path: 'my-screen',
  builder: (context, state) => const MyNewScreen(),
),
```

3. **Navigate to it** using
```dart
context.push('/home/my-screen');
```

---

### Add a New Player

Edit `lib/services/mock_data_service.dart` → `generateMockPlayers()`:

```dart
Player(
  id: 'player_9',
  name: 'João Silva',
  nickname: 'João',
  birthYear: 2000,
  age: 24,
  nationality: 'Brasil',
  city: 'São Paulo',
  languages: 'Português, Inglês',
  club: 'Flamengo',
  league: 'Série A',
  country: 'Brasil',
  contractStatus: ContractStatus.long,
  agent: null,
  status: PlayerStatus.professional,
  positions: [PlayerPosition.st, PlayerPosition.ss],
  primaryPosition: PlayerPosition.st,
  height: 185,
  weight: 82,
  bodyType: BodyType.athletic,
  preferredFoot: Foot.right,
  isVerified: false,
  
  // Physical attributes (0-100)
  paceAcceleration: 88,
  topSpeed: 90,
  stamina: 85,
  strength: 82,
  agility: 86,
  balance: 84,
  jump: 87,
  
  // Technical (0-100)
  passingShort: 76,
  passingLong: 72,
  progressivePass: 74,
  firstTouch: 84,
  ballControl: 86,
  dribbling: 88,
  crossing: 70,
  finishing: 90,
  shotPower: 88,
  heading: 86,
  tackling: 40,
  interception: 38,
  positioning: 88,
  aerialDuels: 85,
  groundDuels: 78,
  weakFootQuality: 72,
  
  // Tactical (0-100)
  buildUp: 65,
  pressResistance: 76,
  decisionMaking: 84,
  scanning: 78,
  offBallMovement: 88,
  defensiveLine: 35,
  pressing: 70,
  recoveryRuns: 66,
  
  // Mental (0-100)
  composure: 84,
  aggression: 76,
  leadership: 80,
  teamwork: 82,
  resilience: 83,
  coachability: 86,
  professionalism: 87,
  gameIQ: 85,
  riskTaking: 74,
  discipline: 82,
  
  styleTags: ['Finalizador', 'Atacante móvel', 'Forte no 1v1'],
  roles: ['Finalizador', 'Atacante de área'],
  strengths: ['Finalização', 'Movimentação', 'Aceleração'],
  weaknesses: ['Defesa', 'Cruzamento'],
  bestSystems: ['4-3-3', '4-2-3-1'],
  bestBlock: TacticalBlock.high,
  description: 'Excelente atacante com boa movimentação de área.',
  estimatedValueMin: 20000000,
  estimatedValueMax: 30000000,
  salaryMin: 150000,
  salaryMax: 220000,
  potential: Potential.high,
  transferRisk: TransferRisk.medium,
  isReadyToLevelUp: true,
  injuryHistory: [],
  injuryRisk: InjuryRisk.low,
  photoUrl: 'https://via.placeholder.com/200/FF6B6B/FFFFFF?text=J.Silva',
  highlightVideos: ['video1', 'video2', 'video3'],
  createdAt: DateTime.now().subtract(const Duration(days: 10)),
  updatedAt: DateTime.now(),
  followers: 5000,
  savedByUsers: [],
),
```

---

### Add a New Filter

Edit `lib/models/models.dart` → `SearchFilters` class:

```dart
class SearchFilters {
  // ... existing fields ...
  
  // Add new field
  final String? myNewFilter;
  
  SearchFilters({
    // ... existing params ...
    this.myNewFilter,
  });

  SearchFilters copyWith({
    // ... existing ...
    String? myNewFilter,
  }) {
    return SearchFilters(
      // ... existing ...
      myNewFilter: myNewFilter ?? this.myNewFilter,
    );
  }
}
```

Then update filter logic in `lib/services/player_repository.dart` → `filterPlayers()`:

```dart
// Add this to the filtering logic
if (filters.myNewFilter != null && player.someField != filters.myNewFilter) {
  return false;
}
```

---

### Add a New Post Feature

Edit `lib/models/models.dart` → `Post` class to add new field, then update `lib/services/post_repository.dart` to handle it.

Example - Add post category:
```dart
class Post {
  // ... existing fields ...
  final String category; // 'gol', 'defesa', 'passe', etc.
  
  Post({
    // ... existing params ...
    required this.category,
  });
}
```

---

### Add a New Notification Type

In `lib/services/other_repositories.dart` → `NotificationRepository`:

```dart
Future<void> notifyPlayerLiked(String userId, String playerId) async {
  final notification = Notification(
    id: const Uuid().v4(),
    userId: userId,
    type: 'player_liked',
    title: 'Seu jogador recebeu um favorito!',
    description: 'Alguém marcou seu jogador como favorito',
    linkedEntityId: playerId,
    timestamp: DateTime.now(),
    isRead: false,
  );
  await addNotification(notification);
}
```

---

## Code Patterns Used

### State Management Pattern
```dart
// In providers
Future<void> myAction() async {
  _isLoading = true;
  notifyListeners();
  
  try {
    // Do something
    await repository.doSomething();
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    rethrow;
  }
}

// In screens
Consumer<MyProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) {
      return const CircularProgressIndicator();
    }
    return MyWidget(data: provider.myData);
  },
)
```

### Navigation Pattern
```dart
// Navigate to screen
context.push('/home/player/${player.id}');

// Navigate with replacement
context.replace('/login');

// Navigate back
context.pop();
```

### Form Validation Pattern
```dart
TextFormField(
  validator: ValidationUtils.validateEmail,
  // or custom validator
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Field required';
    }
    return null;
  },
)
```

---

## Debugging Tips

### Check Provider State
```dart
// In any screen
final provider = context.read<PlayerProvider>();
print(provider.allPlayers.length);
print(provider.filteredPlayers.length);
print(provider.currentFilters);
```

### Check Auth State
```dart
final authProvider = context.read<AuthProvider>();
print('Authenticated: ${authProvider.isAuthenticated}');
print('Current User: ${authProvider.currentUser?.name}');
```

### Enable Flutter Logs
```bash
flutter run -v
```

### Hot Reload Issues
If hot reload doesn't work:
```bash
# Full rebuild
flutter clean
flutter pub get
flutter run

# Or on specific device
flutter run -d chrome
```

---

## Testing

### Test Login
1. Tap "Entrar"
2. Enter any email/password
3. Should navigate to home

### Test Search/Filters
1. Tap search icon
2. Apply filters
3. Results update instantly

### Test Post Actions
1. Tap like → should increment counter
2. Tap save → should show as saved
3. Tap comment → should open comments screen

### Test Favorites
1. Open player profile
2. Tap favorite icon
3. Check profile → should be in watchlist

---

## Common Issues & Solutions

### "null" error on build
**Cause**: Accessing property before data loads
**Fix**: Check `isLoading` and use `?.` operator

### Navigation doesn't work
**Cause**: Wrong route path or missing parameter
**Fix**: Check route definition in `main.dart`

### Provider state not updating
**Cause**: Forgot to call `notifyListeners()`
**Fix**: Ensure all state changes call `notifyListeners()`

### Form validation not working
**Cause**: FormState not validated before submit
**Fix**: Call `_formKey.currentState!.validate()` first

---

## Performance Tips

1. **Use `Consumer` instead of `context.watch`** for better scoping
2. **Avoid rebuilding entire screens** - use Consumer on specific widgets
3. **Cache images** - use network image caching
4. **Lazy load lists** - use `ListView.builder` not `ListView`
5. **Avoid unnecessary `notifyListeners()`** calls

---

## Useful Shortcuts

### Access Current User
```dart
final userId = context.read<AuthProvider>().currentUserId;
```

### Show Snackbar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message')),
);
```

### Show Modal
```dart
showModalBottomSheet(
  context: context,
  builder: (_) => MyModalContent(),
);
```

### Format Currency
```dart
import 'package:futly_talent/utils/utils.dart';

DateUtils.formatCurrency(2500000); // € 2.500.000
```

---

## Key Constants

### Theme Colors
```dart
AppTheme.primaryColor        // Blue
AppTheme.secondaryColor      // Teal
AppTheme.accentColor         // Red
AppTheme.errorColor          // Red
AppTheme.successColor        // Green
AppTheme.warningColor        // Orange
```

### Enums
```dart
PlayerPosition.st            // Striker
PlayerStatus.professional    // Professional
Potential.high              // High potential
TransferRisk.medium         // Medium risk
```

---

## Additional Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Material 3](https://m3.material.io)
- [Dart Documentation](https://dart.dev/guides)

---

## Contributing Guidelines

1. Keep code clean and readable
2. Add comments for complex logic
3. Follow existing patterns
4. Test new features thoroughly
5. Update documentation
6. Use Portuguese for UI strings
7. Use English for code comments

---

*Last Updated: January 2026*
*For Futly Talent Development Team*
