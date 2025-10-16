import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipeNotifier extends StateNotifier<RecipeState> {
  final ApiService _apiService;

  RecipeNotifier(this._apiService) : super(RecipeState.initial()) {
    loadFeaturedRecipes();
  }

  Future<void> loadFeaturedRecipes() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load some popular recipes as featured (you can change the search term)
      final featuredRecipes = await _apiService.searchRecipes('chicken');
      state = state.copyWith(recipes: featuredRecipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load recipes', isLoading: false);
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      // When search is cleared, show featured recipes again
      await loadFeaturedRecipes();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final recipes = await _apiService.searchRecipes(query);
      state = state.copyWith(recipes: recipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to search recipes',
        isLoading: false,
      );
    }
  }

  Future<void> filterByCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final recipes = await _apiService.getRecipesByCategory(category);
      state = state.copyWith(recipes: recipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to filter recipes',
        isLoading: false,
      );
    }
  }

  void clearRecipes() {
    state = state.copyWith(recipes: []);
  }

  // New method to clear filters and show featured recipes
  Future<void> showFeaturedRecipes() async {
    await loadFeaturedRecipes();
  }
}

class RecipeState {
  final List<Recipe> recipes;
  final List<Recipe> featuredRecipes;
  final bool isLoading;
  final String? error;

  RecipeState({
    required this.recipes,
    required this.featuredRecipes,
    required this.isLoading,
    this.error,
  });

  RecipeState.initial()
    : recipes = [],
      featuredRecipes = [],
      isLoading = false,
      error = null;

  RecipeState copyWith({
    List<Recipe>? recipes,
    List<Recipe>? featuredRecipes,
    bool? isLoading,
    String? error,
  }) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      featuredRecipes: featuredRecipes ?? this.featuredRecipes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, RecipeState>(
  (ref) => RecipeNotifier(ApiService()),
);
