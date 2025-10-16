class Recipe {
  final String id;
  final String name;
  final String category;
  final String thumbnail;
  final String instructions;
  final List<Ingredient> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.thumbnail,
    required this.instructions,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];

    // Extract ingredients and measures (API returns them as separate fields)
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(Ingredient(name: ingredient, measure: measure ?? ''));
      }
    }

    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
    );
  }
}

class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});
}
