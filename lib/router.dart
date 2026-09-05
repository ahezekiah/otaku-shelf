import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'ui/pages/splash_page.dart';
import 'ui/pages/discover_page.dart';
import 'ui/pages/detail_page.dart';
import 'ui/pages/favorites_page.dart';
import 'ui/pages/settings_page.dart';

GoRouter appRouter(WidgetRef ref) {
  CustomTransitionPage<T> fadePage<T>(Widget child) => CustomTransitionPage<T>(
    child: child,
    transitionsBuilder: (ctx, anim, sec, child) =>
        FadeTransition(opacity: anim, child: child),
  );

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', pageBuilder: (c, s) => fadePage(const SplashPage())),
      GoRoute(path: '/discover', pageBuilder: (c, s) => fadePage(const DiscoverPage())),
      GoRoute(path: '/favorites', pageBuilder: (c, s) => fadePage(const FavoritesPage())),
      GoRoute(path: '/settings', pageBuilder: (c, s) => fadePage(const SettingsPage())),
      GoRoute(
        path: '/detail',
        pageBuilder: (c, s) => fadePage(DetailPage.fromExtra(s.extra)),
      ),
    ],
  );
}
