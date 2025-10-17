import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_browser_app/models/recipe.dart';
import 'package:recipe_browser_app/models/category.dart';

void main() {
  group('Recipe Model', () {
    test('fromJson creates Recipe with correct data', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Chicken Curry',
        'strCategory': 'Chicken',
        'strMealThumb': 'https://example.com/image.jpg',
        'strInstructions': 'Cook the chicken...',
        'strIngredient1': 'Chicken',
        'strMeasure1': '500g',
        'strIngredient2': 'Curry Powder',
        'strMeasure2': '2 tbsp',
        'strIngredient3': '',
        'strMeasure3': '',
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.id, '1');
      expect(recipe.name, 'Chicken Curry');
      expect(recipe.category, 'Chicken');
      expect(recipe.thumbnail, 'https://example.com/image.jpg');
      expect(recipe.instructions, 'Cook the chicken...');
      expect(recipe.ingredients.length, 2);
      expect(recipe.ingredients[0].name, 'Chicken');
      expect(recipe.ingredients[0].measure, '500g');
      expect(recipe.ingredients[1].name, 'Curry Powder');
      expect(recipe.ingredients[1].measure, '2 tbsp');
    });

    test('fromJson handles empty ingredients', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Simple Recipe',
        'strCategory': 'Simple',
        'strMealThumb': 'https://example.com/image.jpg',
        'strInstructions': 'Instructions',
        'strIngredient1': '',
        'strMeasure1': '',
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.ingredients.length, 0);
    });

    test('fromJson handles null values', () {
      final json = {
        'idMeal': null,
        'strMeal': null,
        'strCategory': null,
        'strMealThumb': null,
        'strInstructions': null,
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.id, '');
      expect(recipe.name, '');
      expect(recipe.category, '');
      expect(recipe.thumbnail, '');
      expect(recipe.instructions, '');
      expect(recipe.ingredients.length, 0);
    });
  });

  group('Category Model', () {
    test('fromJson creates Category with correct data', () {
      final json = {
        'strCategory': 'Chicken',
        'strCategoryThumb': 'https://example.com/category.jpg',
      };

      final category = Category.fromJson(json);

      expect(category.name, 'Chicken');
      expect(category.thumbnail, 'https://example.com/category.jpg');
    });

    test('fromJson handles null values', () {
      final json = {'strCategory': null, 'strCategoryThumb': null};

      final category = Category.fromJson(json);

      expect(category.name, '');
      expect(category.thumbnail, '');
    });
  });
}
