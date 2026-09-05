import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/book.dart';
import '../data/services/open_library_service.dart';

final searchControllerProvider =
StateNotifierProvider<SearchController, SearchState>(
      (ref) => SearchController(),
);

class SearchState {
  final String query;
  final bool loading;
  final List<Book> results;
  final String? error;

  const SearchState({
    this.query = '',
    this.loading = false,
    this.results = const [],
    this.error,
  });

  SearchState copyWith({
    String? query,
    bool? loading,
    List<Book>? results,
    String? error,
  }) =>
      SearchState(
        query: query ?? this.query,
        loading: loading ?? this.loading,
        results: results ?? this.results,
        error: error,
      );
}

class SearchController extends StateNotifier<SearchState> {
  SearchController() : super(const SearchState());

  void setQuery(String q) => state = state.copyWith(query: q, error: null);

  Future<void> run() async {
    final q = state.query.trim();
    if (q.length < 2) {
      state = state.copyWith(error: 'Min 2 characters');
      return;
    }
    state = state.copyWith(loading: true, error: null);
    try {
      final books = await OpenLibraryService.search(q);
      state = state.copyWith(loading: false, results: books);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Search failed');
    }
  }

  void clear() => state = const SearchState();
}
