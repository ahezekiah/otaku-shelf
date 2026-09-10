import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';
import 'state/app_prefs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final Future<AppPrefs> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _prefsFuture = AppPrefs.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppPrefs>(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: const Color(0xFF0F1020),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'OtakuShelf could not start.\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Color(0xFF0F1020),
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFB794F4),
                ),
              ),
            ),
          );
        }

        return ProviderScope(
          overrides: [
            appPrefsProvider.overrideWithValue(snapshot.data!),
          ],
          child: const OtakuShelfApp(),
        );
      },
    );
  }
}

class OtakuShelfApp extends ConsumerWidget {
  const OtakuShelfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'OtakuShelf',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
