import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../providers/category_provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'recipe_list_screen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  OverlayEntry? _overlayEntry;
  String? _selectedCategory;

  void _showCategoryRecipesOverlay(BuildContext context, Category category) {
    // Remove existing overlay if any
    _hideCategoryRecipesOverlay();

    setState(() {
      _selectedCategory = category.name;
    });

    // Create overlay entry
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.black.withOpacity(0.4),
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFf8f7f6),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFe6e0db),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF221810),
                            ),
                            onPressed: _hideCategoryRecipesOverlay,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${category.name} Recipes',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF221810),
                                fontFamily: 'Epilogue',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Recipes List
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final recipeState = ref.watch(recipeProvider);

                          // Load recipes for this category when overlay opens
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (recipeState.recipes.isEmpty ||
                                (recipeState.recipes.isNotEmpty &&
                                    recipeState.recipes.first.category !=
                                        category.name)) {
                              ref
                                  .read(recipeProvider.notifier)
                                  .filterByCategory(category.name);
                            }
                          });

                          return recipeState.isLoading
                              ? const Center(child: _LoadingAnimation())
                              : recipeState.error != null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Error: ${recipeState.error}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontFamily: 'Epilogue',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                              : recipeState.recipes.isEmpty
                              ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.fastfood,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'No recipes found\nin this category',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontFamily: 'Epilogue',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                              : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: recipeState.recipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = recipeState.recipes[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: RecipeCard(
                                      recipe: recipe,
                                      onTap: () {
                                        // Navigate to recipe detail from overlay
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => RecipeDetailScreen(
                                                  recipe: recipe,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    // Insert overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideCategoryRecipesOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  void dispose() {
    _hideCategoryRecipesOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFf8f7f6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf8f7f6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFec6d13)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF221810),
            fontFamily: 'Epilogue',
          ),
        ),
      ),
      body: categoriesAsync.when(
        data:
            (categories) => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(category.thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF221810),
                        fontFamily: 'Epilogue',
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFFec6d13),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  RecipeListScreen(categoryName: category.name),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        loading: () => const Center(child: _BeautifulLoadingAnimation()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading categories: $error',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Epilogue',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

// Beautiful Loading Animation for main screen
class _BeautifulLoadingAnimation extends StatelessWidget {
  const _BeautifulLoadingAnimation();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFec6d13).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFec6d13)),
              strokeWidth: 3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Loading categories...',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF221810),
            fontFamily: 'Epilogue',
          ),
        ),
      ],
    );
  }
}

// Small Loading Animation for overlay
class _LoadingAnimation extends StatelessWidget {
  const _LoadingAnimation();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFec6d13).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFec6d13)),
              strokeWidth: 2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Loading recipes...',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF221810),
            fontFamily: 'Epilogue',
          ),
        ),
      ],
    );
  }
}
