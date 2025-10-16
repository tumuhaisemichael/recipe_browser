import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse('${baseUrl}search.php?s=$query'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => Recipe.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  Future<List<Recipe>> getRecipesByCategory(String category) async {
    final response = await http.get(Uri.parse('${baseUrl}filter.php?c=$category'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        // Need to fetch details for each recipe to get full information
        final List<Recipe> recipes = [];
        for (final meal in data['meals']) {
          final recipe = await getRecipeDetails(meal['idMeal']);
          if (recipe != null) {
            recipes.add(recipe);
          }
        }
        return recipes;
      }
    }
    return [];
  }

  Future<Recipe?> getRecipeDetails(String id) async {
    final response = await http.get(Uri.parse('${baseUrl}lookup.php?i=$id'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null && data['meals'].isNotEmpty) {
        return Recipe.fromJson(data['meals'][0]);
      }
    }
    return null;
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('${baseUrl}categories.php'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['categories'] != null) {
        return (data['categories'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
      }
    }
    return [];
  }
}