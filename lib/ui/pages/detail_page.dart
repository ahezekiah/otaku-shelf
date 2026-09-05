import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/app_prefs.dart';

class DetailPage extends ConsumerStatefulWidget {
  final String type; // 'book' | 'manga'
  final dynamic data; // Book | Manga
  final Object? heroTag;
  const DetailPage({super.key, required this.type, required this.data, this.heroTag});

  factory DetailPage.fromExtra(Object? extra) {
    final map = extra as Map<String, dynamic>;
    return DetailPage(type: map['type'], data: map['data'], heroTag: map['heroTag']);
  }

  @override
  ConsumerState<DetailPage> createState() => _DetailState();
}

class _DetailState extends ConsumerState<DetailPage> {
  final _form = GlobalKey<FormState>();
  final _noteCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prefs = ref.read(appPrefsProvider);
    final favs = ref.watch(favoritesProvider);

    final id = widget.type == 'book'
        ? widget.data.key as String
        : (widget.data.malId as int).toString();
    final title = widget.data.title as String;
    final image = widget.type == 'book' ? widget.data.coverUrl : widget.data.imageUrl;

    final isFav = favs.any((e) => e['id'] == id && e['type'] == widget.type);

    final img = (image != null)
        ? ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: widget.heroTag == null
          ? Image.network(image, height: 260, fit: BoxFit.cover)
          : Hero(
        tag: widget.heroTag!,
        child: Image.network(image, height: 260, fit: BoxFit.cover),
      ),
    )
        : const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: Text(title)
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          img,
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton.tonalIcon(
                onPressed: () {
                  if (isFav) {
                    ref.read(favoritesProvider.notifier).remove(id, widget.type, prefs);
                  } else {
                    ref.read(favoritesProvider.notifier).addOrUpdate({
                      'id': id,
                      'type': widget.type,
                      'title': title,
                      'image': image
                    }, prefs);
                  }
                },
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                label: Text(isFav ? 'Remove from Favorites' : 'Add to Favorites'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Add a personal review', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Form(
            key: _form,
            child: TextFormField(
              controller: _noteCtrl,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'What did you love about this manga? (min 10 chars)',
              ),
              validator: (v) =>
              (v == null || v.trim().length < 10) ? 'Please write at least 10 characters' : null,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              if (!_form.currentState!.validate()) return;
              ref.read(favoritesProvider.notifier).addOrUpdate({
                'id': id,
                'type': widget.type,
                'title': title,
                'image': image,
                'note': _noteCtrl.text.trim(),
              }, prefs);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Review Saved')));
              _noteCtrl.clear();
            },
            child: const Text('Save Review'),
          ),
        ],
      ),
    );
  }
}
