import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../state/app_prefs.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  void _go(BuildContext context, int i) {
    switch (i) {
      case 0: context.go('/discover'); break;
      case 1: context.go('/favorites'); break;
      case 2: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(appPrefsProvider);
    final favs = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favs.isEmpty
          ? const Center(child: Text('Nothing yet. Add something you\'ll love!'))
          : ListView.separated(
        itemCount: favs.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final f = favs[i];
          return AnimatedOpacity(
            opacity: 1,
            duration: Duration(milliseconds: 250 + i * 15),
            curve: Curves.easeOut,
            child: ListTile(
              leading: f['image'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(f['image'], width: 50, height: 50, fit: BoxFit.cover),
              )
                  : const Icon(Icons.image_not_supported),
              title: Text(f['title'] ?? 'Untitled'),
              subtitle: Text('${f['type'] == 'book' ? 'Book' : 'Manga'} • ${f['note'] != null ? 'Has Review' : 'No Review'}'),
              onTap: () => context.push('/detail', extra: {
                'type': f['type'],
                'data': _LiteModel(f), // lightweight pass
                'heroTag': null,
              }),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => ref.read(favoritesProvider.notifier).remove(
                  f['id'] as String,
                  f['type'] as String,
                  prefs,
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (i) => _go(context, i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

/// tiny helper to reuse the detail UI without full types
class _LiteModel {
  final String title;
  final String? imageUrl;
  final String? key;
  final int? malId;
  _LiteModel(Map<String, dynamic> f)
      : title = f['title'] ?? 'Untitled',
        imageUrl = f['image'],
        key = f['type'] == 'book' ? f['id'] : null,
        malId = f['type'] == 'anime' ? int.tryParse(f['id']) : null;
}
