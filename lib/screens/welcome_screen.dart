import 'package:flutter/material.dart';
import 'recipe_list_screen.dart';
import 'recipe_list_screen.dart'; // Make sure this path is correct

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFf8f7f6), // background-light
        child: SafeArea(
          child: Column(
            children: [
              // Main content area - centered
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon container with orange background
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFf97316,
                            ).withOpacity(0.2), // primary/20
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            size: 48,
                            color: Color(0xFFf97316), // primary
                          ),
                        ),
                        // Title
                        const Text(
                          'Recipe Browser',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1c1917), // background-dark
                            fontFamily: 'Epilogue',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Subtitle
                        RichText(
                          text: const TextSpan(
                            text:
                                'Discover delicious recipes tailored to your ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1c1917), // background-dark
                              fontFamily: 'Epilogue',
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'tastes.',
                                style: TextStyle(
                                  color: Color(0xFFf97316), // primary
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Button section at bottom
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecipeListScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf97316), // primary
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // rounded-lg
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Browsing',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Epilogue',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
