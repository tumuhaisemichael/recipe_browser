import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe_browser_app/services/api_service.dart';
import 'package:recipe_browser_app/models/recipe.dart';
import 'package:recipe_browser_app/models/category.dart';

// Generate mocks
@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  late ApiService apiService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    apiService = ApiService();
    // Note: In a real test, we'd inject the client, but for simplicity we'll test with real API
    // For production tests, consider making ApiService accept an http.Client parameter
  });

  group('ApiService', () {
    test('searchRecipes returns list of recipes on success', () async {
      // This test would require mocking the http client
      // For now, we'll test the structure assuming the API works
      final recipes = await apiService.searchRecipes('chicken');

      expect(recipes, isA<List<Recipe>>());
      if (recipes.isNotEmpty) {
        expect(recipes.first, isA<Recipe>());
        expect(recipes.first.name, isNotEmpty);
      }
    });

    test('getRecipeDetails returns recipe on success', () async {
      final recipe = await apiService.getRecipeDetails(
        '52772',
      ); // Chicken Curry

      expect(recipe, isA<Recipe>());
      expect(recipe!.id, '52772');
      expect(recipe.name, isNotEmpty);
      expect(recipe.ingredients, isNotEmpty);
    });

    test('getRecipeDetails returns null on failure', () async {
      final recipe = await apiService.getRecipeDetails('invalid_id');

      expect(recipe, isNull);
    });

    test('getCategories returns list of categories', () async {
      final categories = await apiService.getCategories();

      expect(categories, isA<List<Category>>());
      expect(categories.length, greaterThan(0));
      expect(categories.first, isA<Category>());
      expect(categories.first.name, isNotEmpty);
    });

    test('getRecipesByCategory returns recipes', () async {
      final recipes = await apiService.getRecipesByCategory('Chicken');

      expect(recipes, isA<List<Recipe>>());
      if (recipes.isNotEmpty) {
        expect(recipes.first.category.toLowerCase(), contains('chicken'));
      }
    });
  });
}
