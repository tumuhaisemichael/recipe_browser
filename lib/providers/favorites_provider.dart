import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  static const String _favoritesKey = 'favorite_recipes';

  FavoritesNotifier() : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    state = favorites.toSet();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, state.toList());
  }

  void toggleFavorite(Recipe recipe) {
    if (state.contains(recipe.id)) {
      state = {...state}..remove(recipe.id);
    } else {
      state = {...state}..add(recipe.id);
    }
    _saveFavorites();
  }

  bool isFavorite(String recipeId) {
    return state.contains(recipeId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);
