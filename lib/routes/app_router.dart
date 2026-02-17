import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/view/about_screen.dart';
import 'package:gallery_application/view/bin_screen.dart';
import 'package:gallery_application/view/detail_screen.dart';
import 'package:gallery_application/view/home_screen.dart';
import 'package:gallery_application/view/liked_screen.dart';
import 'package:gallery_application/view/locked_folder_screen.dart';
import 'package:gallery_application/view/main_screen.dart';
import 'package:gallery_application/view/privacy_policy_screen.dart';
import 'package:gallery_application/view/settings_screen.dart';
import 'package:gallery_application/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(name: 'splash', path: "/", builder: (context, state) => SplashScreen()),
      GoRoute(name: 'main', path: "/main", builder:(context, state) => MainScreen()),
      GoRoute(name: 'home', path: "/home", builder: (context, state) => HomeScreen()),
      GoRoute(name: 'detail', path: "/detail", builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          final mediaList = data['mediaList'] as List<MediaModel>;
          final initialIndex = data['initialIndex'] as int;
          final source = data['source'] as String;

          return DetailScreen(mediaList: mediaList, initialIndex: initialIndex, source: source);
        },
      ),
      GoRoute(name: 'liked', path: "/liked", builder: (context, state) => LikedScreen()),
      GoRoute(name: 'settings', path: "/settings", builder: (context, state) => SettingsScreen()),
      GoRoute(name: 'about', path: "/about", builder: (context, state) => AboutScreen()),
      GoRoute(name: 'privacy', path: "/privacy", builder: (context, state) => PrivacyPolicyScreen()),
      GoRoute(name: 'bin', path: "/bin", builder: (context, state) => BinScreen()),
      GoRoute(name: 'lock', path: "/lock", builder: (context, state) => LockedFolderScreen()),
    ]
  );
}