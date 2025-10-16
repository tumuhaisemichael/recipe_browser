import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/category_filter.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'favorites_screen.dart';

class RecipeListScreen extends ConsumerStatefulWidget {
  const RecipeListScreen({super.key});

  @override
  ConsumerState<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends ConsumerState<RecipeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load some initial recipes when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recipeProvider.notifier).loadFeaturedRecipes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final favoriteRecipes =
        recipeState.recipes
            .where((recipe) => favoriteIds.contains(recipe.id))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFf8f7f6), // background-light
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Search Bar
            _buildSearchBar(),
            // Categories Section
            _buildCategoriesSection(categoriesAsync),
            // Favorites Section
            _buildFavoritesSection(favoriteRecipes),
            // Recipes List Section
            _buildRecipesList(recipeState),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recipe Finder',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFec6d13), // primary
              fontFamily: 'Epilogue',
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFec6d13).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFFec6d13)),
              onPressed: () {
                // Handle logout
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF221810).withOpacity(0.05), // background-dark/5
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search recipes',
            hintStyle: TextStyle(
              color: const Color(0xFF221810).withOpacity(0.5),
              fontFamily: 'Epilogue',
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: const Color(0xFFec6d13), // primary
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              ref.read(recipeProvider.notifier).loadFeaturedRecipes();
            } else {
              ref.read(recipeProvider.notifier).searchRecipes(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(AsyncValue<List<Category>> categoriesAsync) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF221810), // background-dark
              fontFamily: 'Epilogue',
            ),
          ),
          const SizedBox(height: 12),
          categoriesAsync.when(
            data:
                (categories) => SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(recipeProvider.notifier)
                                .filterByCategory(category.name);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFec6d13,
                            ).withOpacity(0.1),
                            foregroundColor: const Color(0xFFec6d13),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Epilogue',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            loading:
                () => const SizedBox(
                  height: 40,
                  child: Center(child: _LoadingAnimation()),
                ),
            error:
                (error, stack) => const SizedBox(
                  height: 40,
                  child: Center(child: Text('Failed to load categories')),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection(List<Recipe> favoriteRecipes) {
    if (favoriteRecipes.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorites',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF221810),
              fontFamily: 'Epilogue',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      // Recipe Image
                      Container(
                        width: 160,
                        height: 160 * 4 / 3, // aspect ratio 3:4
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(recipe.thumbnail),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Recipe Name
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF221810),
                          fontFamily: 'Epilogue',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList(RecipeState recipeState) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            recipeState.isLoading
                ? const Center(child: _BeautifulLoadingAnimation())
                : recipeState.error != null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${recipeState.error}',
                        style: const TextStyle(
                          fontSize: 16,
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
                      Icon(Icons.search, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No recipes found\nTry searching or select a category',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Epilogue',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  itemCount: recipeState.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipeState.recipes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFf8f7f6),
        border: Border(
          top: BorderSide(color: const Color(0xFF221810).withOpacity(0.1)),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, true),
              _buildNavItem(Icons.favorite, 'Favorites', 1, false),
              _buildNavItem(Icons.category, 'Categories', 2, false),
              _buildNavItem(Icons.person, 'Profile', 3, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
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
                    : const Color(0xFF221810).withOpacity(0.5),
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
                      : const Color(0xFF221810).withOpacity(0.5),
              fontFamily: 'Epilogue',
            ),
          ),
        ],
      ),
    );
  }
}

// Beautiful Loading Animation
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
          'Loading delicious recipes...',
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

// Small Loading Animation for categories
class _LoadingAnimation extends StatelessWidget {
  const _LoadingAnimation();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          const Color(0xFFec6d13).withOpacity(0.5),
        ),
      ),
    );
  }
}
