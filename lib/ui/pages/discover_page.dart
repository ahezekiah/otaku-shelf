import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/book.dart';
import '../../../data/models/anime.dart';
import '../../../data/services/open_library_service.dart';
import '../../../data/services/jikan_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/network_image_card.dart';
import '../widgets/rating_chip.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});
  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverState();
}

class _DiscoverState extends ConsumerState<DiscoverPage> {
  final _form = GlobalKey<FormState>();
  final _ctrl = TextEditingController();
  List<Book> _books = [];
  List<Anime> _anime = [];
  bool _loading = false;
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    _loadAnime();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _animateIn = true);
    });
  }

  Future<void> _loadAnime() async {
    setState(() => _loading = true);
    _anime = await JikanService.topAnime();
    setState(() => _loading = false);
  }

  Future<void> _search() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    _books = await OpenLibraryService.search(_ctrl.text.trim());
    setState(() => _loading = false);
  }

  void _go(int i) {
    switch (i) {
      case 0: context.go('/discover'); break;
      case 1: context.go('/favorites'); break;
      case 2: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Form(
              key: _form,
              child: TextFormField(
                controller: _ctrl,
                decoration: const InputDecoration(
                  labelText: 'Search for mangas…',
                  prefixIcon: Icon(Icons.search),
                ),
                validator: (v) =>
                (v == null || v.trim().length < 2) ? 'Min 2 characters' : null,
                onFieldSubmitted: (_) => _search(),
              ),
            ),
            const SizedBox(height: 12),
            if (_loading) const LinearProgressIndicator(),
            Expanded(
              child: ListView(
                children: [
                  if (_books.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 6),
                      child: Text('Mangas', style: Theme.of(context).textTheme.titleMedium),
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _books.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final b = _books[i];
                          final hero = 'book-${b.key}';
                          final card = NetworkImageCard(
                            title: b.title,
                            subtitle: b.author ?? '',
                            imageUrl: b.coverUrl,
                            heroTag: hero,
                            onTap: () => context.push('/detail', extra: {
                              'type': 'book',
                              'data': b,
                              'heroTag': hero,
                            }),
                          );
                          return _stagger(card, i);
                        },
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 6),
                    child: Text('Top Mangas', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  SizedBox(
                    height: 240,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _anime.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final a = _anime[i];
                        final hero = 'anime-${a.malId}';
                        final card = NetworkImageCard(
                          title: a.title,
                          subtitle: a.score != null ? 'Score ${a.score!.toStringAsFixed(1)}' : '',
                          imageUrl: a.imageUrl,
                          heroTag: hero,
                          footer: RatingChip(score: a.score), // 👈 chip under the texts
                          onTap: () => context.push('/detail', extra: {
                            'type': 'anime',
                            'data': a,
                            'heroTag': hero,
                          }),
                        );
                        return _stagger(card, i);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav( // 👈 custom non-default nav
        currentIndex: 0,
        onTap: _go,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _search,
        icon: const Icon(Icons.search),
        label: const Text('Search'),
      ),
    );
  }

  Widget _stagger(Widget child, int i) => AnimatedOpacity(
    opacity: _animateIn ? 1 : 0,
    duration: Duration(milliseconds: 300 + i * 25),
    curve: Curves.easeOut,
    child: AnimatedScale(
      scale: _animateIn ? 1 : 0.96,
      duration: Duration(milliseconds: 300 + i * 25),
      curve: Curves.easeOut,
      child: child,
    ),
  );
}

