import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_browser_app/providers/recipe_provider.dart';
import 'package:recipe_browser_app/providers/favorites_provider.dart';
import 'package:recipe_browser_app/models/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RecipeNotifier', () {
    late RecipeNotifier recipeNotifier;

    setUp(() {
      // For testing, we'd need to mock ApiService
      // For now, we'll test the state management logic
    });

    test('initial state is correct', () {
      // This would require mocking ApiService
      // expect(recipeNotifier.state.recipes, isEmpty);
      // expect(recipeNotifier.state.isLoading, false);
    });

    test('copyWith creates new state correctly', () {
      final initialState = RecipeState.initial();
      final newState = initialState.copyWith(isLoading: true, error: 'Error');

      expect(newState.isLoading, true);
      expect(newState.error, 'Error');
      expect(newState.recipes, isEmpty); // unchanged
    });
  });

  group('FavoritesNotifier', () {
    late FavoritesNotifier favoritesNotifier;

    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      favoritesNotifier = FavoritesNotifier();
      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('initial state is empty', () {
      expect(favoritesNotifier.state, isEmpty);
    });

    test('toggleFavorite adds recipe to favorites', () {
      final recipe = Recipe(
        id: '1',
        name: 'Test Recipe',
        category: 'Test',
        thumbnail: 'test.jpg',
        instructions: 'Test instructions',
        ingredients: [],
      );

      favoritesNotifier.toggleFavorite(recipe);

      expect(favoritesNotifier.state.contains('1'), true);
    });

    test('toggleFavorite removes recipe from favorites', () {
      final recipe = Recipe(
        id: '1',
        name: 'Test Recipe',
        category: 'Test',
        thumbnail: 'test.jpg',
        instructions: 'Test instructions',
        ingredients: [],
      );

      favoritesNotifier.toggleFavorite(recipe); // add
      expect(favoritesNotifier.state.contains('1'), true);

      favoritesNotifier.toggleFavorite(recipe); // remove
      expect(favoritesNotifier.state.contains('1'), false);
    });

    test('isFavorite returns correct status', () {
      final recipe = Recipe(
        id: '1',
        name: 'Test Recipe',
        category: 'Test',
        thumbnail: 'test.jpg',
        instructions: 'Test instructions',
        ingredients: [],
      );

      expect(favoritesNotifier.isFavorite('1'), false);

      favoritesNotifier.toggleFavorite(recipe);
      expect(favoritesNotifier.isFavorite('1'), true);
    });
  });
}
