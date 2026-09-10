import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/pages/splash_page.dart';
import 'ui/pages/discover_page.dart';
import 'ui/pages/detail_page.dart';
import 'ui/pages/favorites_page.dart';
import 'ui/pages/settings_page.dart';

CustomTransitionPage<void> fadePage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) {
        return fadePage(state, const SplashPage());
      },
    ),
    GoRoute(
      path: '/discover',
      pageBuilder: (context, state) {
        return fadePage(state, const DiscoverPage());
      },
    ),
    GoRoute(
      path: '/favorites',
      pageBuilder: (context, state) {
        return fadePage(state, const FavoritesPage());
      },
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        return fadePage(state, const SettingsPage());
      },
    ),
    GoRoute(
      path: '/detail',
      pageBuilder: (context, state) {
        return fadePage(
          state,
          DetailPage.fromExtra(state.extra),
        );
      },
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.error?.toString() ?? 'The requested page could not be opened.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  },
);
