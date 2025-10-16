import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/recipe_provider.dart';

class CategoryFilter extends ConsumerWidget {
  final List<Category> categories;

  const CategoryFilter({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category.name),
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(recipeProvider.notifier)
                      .filterByCategory(category.name);
                } else {
                  // Optionally clear filter if deselected
                  ref.read(recipeProvider.notifier).clearRecipes();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
