import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appPrefsProvider = Provider<AppPrefs>((_) => throw UnimplementedError());

final themeModeProvider = StateNotifierProvider<_ThemeMode, bool>(
      (ref) => _ThemeMode(ref.read(appPrefsProvider).isDark),
);

final favoritesProvider =
StateNotifierProvider<FavoritesController, List<Map<String, dynamic>>>((ref) {
  final prefs = ref.read(appPrefsProvider);
  return FavoritesController(prefs.loadFavorites());
});

class AppPrefs {
  final SharedPreferences _sp;
  AppPrefs._(this._sp);
  static Future<AppPrefs> init() async => AppPrefs._(await SharedPreferences.getInstance());

  bool get isDark => _sp.getBool('isDark') ?? false;
  Future<void> setDark(bool v) => _sp.setBool('isDark', v);

  List<Map<String, dynamic>> loadFavorites() {
    final raw = _sp.getString('favorites') ?? '[]';
    final list = (json.decode(raw) as List).cast<Map>();
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> saveFavorites(List<Map<String, dynamic>> items) =>
      _sp.setString('favorites', json.encode(items));
}

class _ThemeMode extends StateNotifier<bool> {
  _ThemeMode(super.initial);
  void toggle(AppPrefs prefs) {
    state = !state;
    prefs.setDark(state);
  }
}

class FavoritesController extends StateNotifier<List<Map<String, dynamic>>> {
  FavoritesController(super.initial);

  void addOrUpdate(Map<String, dynamic> item, AppPrefs prefs) {
    final id = item['id'];
    final type = item['type'];
    final idx = state.indexWhere((e) => e['id'] == id && e['type'] == type);
    if (idx >= 0) {
      final copy = [...state];
      copy[idx] = {...copy[idx], ...item};
      state = copy;
    } else {
      state = [...state, item];
    }
    prefs.saveFavorites(state);
  }

  void remove(String id, String type, AppPrefs prefs) {
    state = state.where((e) => !(e['id'] == id && e['type'] == type)).toList();
    prefs.saveFavorites(state);
  }
}
