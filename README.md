# Futly Talent - Flutter App

A comprehensive talent discovery and player database application built with Flutter, featuring a social feed, detailed player profiles, advanced search filters, and community engagement.

## Features

### Core Functionality
- **Authentication**: Login, Register, Password Reset (fully mocked)
- **Home Feed**: Instagram/TikTok-style social feed with posts
- **Player Search**: Advanced filtering by position, age, height, league, and more
- **Player Profiles**: Extremely detailed profiles with multiple tabs (overview, analysis, evolution, content, notes, market data)
- **Social Features**: Like, comment, repost, save, and share functionality
- **Direct Messages**: Chat with other users (mocked)
- **Notifications**: Push notifications for user interactions
- **Comparisons**: Side-by-side player comparisons
- **User Profiles**: Personal dashboard with created players, saved favorites, posts

### Player Data
- **60+ Mock Players**: Spanning all football positions and leagues
- **Comprehensive Attributes**:
  - Physical: pace, stamina, strength, agility, balance, jump
  - Technical: passing, dribbling, finishing, tackling, etc.
  - Tactical: positioning, pressing, decision-making
  - Mental: composure, leadership, resilience
  - Market: estimated value, salary, transfer risk, potential
- **Qualitative Data**: Style tags, roles, strengths, weaknesses, best systems

### UI/UX
- **Material 3 Design**: Modern, clean, premium interface
- **Portuguese Language**: All user-visible strings in pt-BR
- **Responsive Layout**: Works on all screen sizes
- **Bottom Navigation**: 5-tab navigation (Home, Compare, Create, Notifications, Profile)
- **Persistent Navigation**: Back arrows on all secondary screens

## Tech Stack

- **Framework**: Flutter 3.x with null safety
- **State Management**: Provider 6.0
- **Navigation**: go_router 14.0
- **Local Storage**: shared_preferences 2.2
- **HTTP**: Mock data service (no real backend)
- **UI**: Material 3 + Google Fonts
- **Utilities**: intl, uuid

## Project Structure

```
futly_talent/
├── lib/
│   ├── main.dart                    # App entry point and routing
│   ├── theme/
│   │   └── app_theme.dart          # Material 3 theme configuration
│   ├── models/
│   │   └── models.dart             # All data models and enums
│   ├── services/
│   │   ├── mock_data_service.dart  # Mock data generation
│   │   ├── player_repository.dart  # Player data access
│   │   ├── post_repository.dart    # Post data access
│   │   └── other_repositories.dart # User, notification, etc.
│   ├── providers/
│   │   ├── auth_provider.dart      # Authentication state
│   │   ├── player_provider.dart    # Players state
│   │   ├── post_provider.dart      # Posts state
│   │   └── user_provider.dart      # Users/notifications/DMs state
│   ├── screens/
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── reset_password_screen.dart
│   │   ├── main_screen.dart        # Bottom nav + home screen
│   │   └── other_screens.dart      # Additional screens
│   ├── widgets/                    # Reusable widgets (expandable)
│   └── utils/
│       └── utils.dart              # Utilities (dates, strings, validation)
├── assets/
│   └── images/                     # Placeholder images
├── pubspec.yaml                    # Dependencies
└── README.md                       # This file
```

## Installation & Setup

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio or Xcode (for emulator/device)

### Steps

1. **Clone the project**
   ```bash
   cd "g:\Sites e Apps\futly talent"
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

   Or run on a specific device:
   ```bash
   flutter run -d chrome          # Web
   flutter run -d emulator-5554   # Android emulator
   flutter run -d iphone          # iOS simulator
   ```

## Usage

### First Launch
1. Tap **"Continuar sem login"** to browse as guest, or
2. Tap **"Entrar"** to login with any email/password
3. Tap **"Criar conta"** to register (any email/password works in mock mode)

### Main Navigation
- **Home (🏠)**: Social feed with posts
- **Compare (🔄)**: Compare two players side-by-side
- **Create (+)**: Create a new post or player profile
- **Notifications (🔔)**: View app notifications
- **Profile (👤)**: Your user profile and settings

### Features to Explore
- **Search**: Tap search icon on home to find players by position, age, club, etc.
- **Player Profile**: Tap a player card or reference to view detailed profile
- **Post Actions**: Like, comment, repost, save, or share any post
- **Messages**: Tap DM icon to send direct messages
- **Favorites**: Save players to your watchlist

## Mock Data

All data is mocked and stored in memory:
- **Players**: 8+ base players + ability to create more
- **Posts**: 5+ initial posts
- **Users**: 5 mock users
- **Comments**: Comments can be added dynamically
- **Notifications**: Generated on-demand

### Important Notes
- **No Backend**: All data is local and resets on app restart
- **Login Persistence**: Login state persists using `shared_preferences`
- **Instant Actions**: All operations complete with simulated delay (200-1000ms)
- **No Network**: All network calls are mocked with `Future.delayed()`

## Data Models

### Key Models
- **Player**: Complete player profile with 40+ attributes
- **Post**: Social media post with engagement metrics
- **User**: User profile with stats and verification
- **Comment**: Post comments with likes
- **Notification**: User notifications
- **Conversation**: Direct messages between users
- **SearchFilters**: Advanced filtering options

### Enums
- **PlayerPosition**: 15 football positions (GK, RB, LB, CB, RCB, LCB, RWB, LWB, DM, CM, AM, RW, LW, SS, ST)
- **PlayerStatus**: Base, Professional, Without Club, Returning from Injury
- **Potential**: Low, Medium, High
- **TacticalBlock**: High, Medium, Low
- And more...

## Customization

### Add More Players
Edit `lib/services/mock_data_service.dart` and add to `generateMockPlayers()`:

```dart
Player(
  id: 'player_9',
  name: 'Your Player Name',
  // ... other properties
)
```

### Change Theme Colors
Edit `lib/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF1E40AF); // Change this
```

### Modify Filter Options
Edit `lib/models/models.dart` and update `SearchFilters` class.

## Common Tasks

### Login with Test Account
- Email: `test@email.com`
- Password: `123456` (any combination works)

### View All Players
1. Tap Search (🔍) on home screen
2. Filters are pre-populated with all players
3. Use filters to narrow down

### Create a Post
1. Tap the + icon (requires login)
2. Select media (photo/video)
3. Choose linked player
4. Add caption and tags
5. Publish

### Send a Message
1. Tap DM icon (envelope) on home
2. Select a user to chat with
3. Type and send message

## Performance Notes

- App runs at 60 FPS on most devices
- No real network calls (all mocked)
- Smooth animations and transitions
- Optimized list rendering with separators

## Known Limitations

- **No Real Backend**: All data is local
- **No Image Upload**: Uses placeholder images from internet
- **No Video Streaming**: Mock video player only
- **No Location Services**: Location data is static
- **No Notifications**: No push notifications (local only)

## Future Enhancements

- Real backend integration
- Real-time messaging with Socket.io
- Video upload and streaming
- Advanced analytics and heatmaps
- Player tracking and scouting reports
- AI-powered player recommendations
- Integration with official stats APIs

## Troubleshooting

### App crashes on startup
- Run `flutter clean`
- Run `flutter pub get`
- Run `flutter run`

### Null safety errors
- Make sure Flutter SDK is 3.0+
- Run `flutter upgrade`

### Slow performance
- Close other apps
- Clear app cache
- Restart device

### Images not loading
- Check internet connection (for placeholder images)
- Images use external CDN (via.placeholder.com)

## Contributing

This is a demo/educational project. Feel free to fork and customize!

## License

MIT License - Feel free to use this code for any purpose.

## Support

For issues or questions, refer to the Flutter documentation:
- [Flutter Docs](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)

---

**Version**: 1.0.0  
**Last Updated**: January 2026  
**Built with**: Flutter 3.x, Dart 3.x
#   f u t l y _ t a l e n t  
 