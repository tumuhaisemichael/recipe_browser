import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../providers/favorites_provider.dart';
import 'recipe_list_screen.dart';
import 'favorites_screen.dart';
import 'categories_screen.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  final Set<int> _checkedIngredients = {};
  int _currentIndex = 0;

  bool get isFavorite =>
      ref.watch(favoritesProvider).contains(widget.recipe.id);

  void _toggleIngredient(int index) {
    setState(() {
      if (_checkedIngredients.contains(index)) {
        _checkedIngredients.remove(index);
      } else {
        _checkedIngredients.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f7f6), // background-light
      body: SafeArea(
        child: Column(
          children: [
            // Header Image with Back Button
            _buildHeaderImage(context),
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Title and Description
                    _buildRecipeHeader(),
                    // Ingredients Section
                    _buildIngredientsSection(),
                    // Instructions Section
                    _buildInstructionsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 320,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.recipe.thumbnail),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFf8f7f6).withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF221810), // content-light
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        // Favorite Button
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFf8f7f6).withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color:
                    isFavorite
                        ? const Color(0xFFec6d13)
                        : const Color(0xFF221810),
                size: 20,
              ),
              onPressed: () {
                final favoritesNotifier = ref.read(favoritesProvider.notifier);
                favoritesNotifier.toggleFavorite(widget.recipe);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.recipe.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF221810), // content-light
            fontFamily: 'Epilogue',
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getRecipeDescription(),
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF897261), // content-subtle-light
            fontFamily: 'Epilogue',
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF221810), // content-light
              fontFamily: 'Epilogue',
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children:
                widget.recipe.ingredients.asMap().entries.map((entry) {
                  final index = entry.key;
                  final ingredient = entry.value;
                  final isChecked = _checkedIngredients.contains(index);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        // Checkbox
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFe6e0db), // border-light
                              width: 2,
                            ),
                            color:
                                isChecked
                                    ? const Color(0xFFec6d13)
                                    : Colors.transparent,
                          ),
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.transparent,
                            ),
                            child: Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                _toggleIngredient(index);
                              },
                              activeColor: const Color(0xFFec6d13),
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Ingredient Text
                        Expanded(
                          child: Text(
                            '${ingredient.measure} ${ingredient.name}',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF221810), // content-light
                              fontFamily: 'Epilogue',
                              decoration:
                                  isChecked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                              decorationColor: const Color(0xFFec6d13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    final instructions = _parseInstructions(widget.recipe.instructions);

    return Container(
      margin: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instructions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF221810), // content-light
              fontFamily: 'Epilogue',
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children:
                instructions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final instruction = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step Number
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFec6d13), // primary
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Epilogue',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Instruction Text
                        Expanded(
                          child: Text(
                            instruction,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF221810), // content-light
                              fontFamily: 'Epilogue',
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFf8f7f6).withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFe6e0db), // border-light
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, true, context),
              _buildNavItem(Icons.favorite, 'Favorites', 1, false, context),
              _buildNavItem(Icons.category, 'Categories', 2, false, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    bool isActive,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        if (index == 0) {
          // Navigate to Home (RecipeListScreen)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RecipeListScreen()),
            (route) => false,
          );
        } else if (index == 1) {
          // Navigate to Favorites
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
        } else if (index == 2) {
          // Navigate to Categories
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoriesScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                isActive
                    ? const Color(0xFFec6d13)
                    : const Color(0xFF897261), // primary : content-subtle-light
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  isActive
                      ? const Color(0xFFec6d13)
                      : const Color(
                        0xFF897261,
                      ), // primary : content-subtle-light
              fontFamily: 'Epilogue',
            ),
          ),
        ],
      ),
    );
  }

  String _getRecipeDescription() {
    return "This delicious ${widget.recipe.name.toLowerCase()} is a perfect meal for any occasion. Made with fresh ingredients and easy-to-follow instructions, it's sure to become a family favorite.";
  }

  List<String> _parseInstructions(String instructions) {
    // Split instructions by new lines or numbers
    final lines =
        instructions
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();

    if (lines.length > 1) {
      return lines;
    }

    // If it's one long paragraph, split by periods and filter empty strings
    return instructions
        .split('.')
        .where((sentence) => sentence.trim().isNotEmpty)
        .map((sentence) => '${sentence.trim()}.')
        .toList();
  }
}
