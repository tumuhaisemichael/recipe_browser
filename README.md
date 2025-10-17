# Recipe Browser

A Flutter-based mobile app that lets users browse, search, and view recipes from TheMealDB API. It features recipe lists, category filters, detailed views with ingredients and instructions, smooth navigation, and responsive UI built with robust state management.

## Setup Instructions

To run the app locally, follow these steps:

1. **Prerequisites**:
   - Install Flutter SDK (version 3.7.2 or higher) from [flutter.dev](https://flutter.dev/docs/get-started/install).
   - Ensure you have Android Studio or Xcode set up for mobile development.
   - Verify Flutter installation: `flutter doctor`.

2. **Clone the Repository**:
   ```
   git clone <repository-url>
   cd recipe_browser
   ```

3. **Install Dependencies**:
   ```
   flutter pub get
   ```

4. **Run the App**:
   - For Android: `flutter run` (ensure an emulator or device is connected).
   - For iOS: `flutter run` (on macOS with Xcode).
   - For Web: `flutter run -d chrome`.

The app uses TheMealDB API, which is public and requires no API key.

## Architecture Decisions

### State Management
- **Choice**: Riverpod (flutter_riverpod) for state management.
- **Reason**: Provides a simple, scalable way to manage app state with providers and notifiers. Chosen over Provider for better testability and separation of concerns. StateNotifier is used for complex state logic in RecipeNotifier.

### Folder Structure
- `lib/main.dart`: App entry point with ProviderScope.
- `lib/models/`: Data models (Recipe, Ingredient, Category) for API responses.
- `lib/providers/`: State management providers (RecipeNotifier, CategoryProvider, FavoritesProvider).
- `lib/screens/`: UI screens (WelcomeScreen, RecipeListScreen, etc.).
- `lib/services/`: API service layer (ApiService for HTTP calls to TheMealDB).
- `lib/widgets/`: Reusable UI components (RecipeCard, CategoryFilter, etc.).
- **Rationale**: Follows standard Flutter project structure for maintainability. Separates concerns between data, business logic, and UI.

### Navigation
- Uses MaterialPageRoute for screen navigation (e.g., from WelcomeScreen to RecipeListScreen).
- Bottom navigation bar for quick access to Home, Favorites, and Categories.
- **Tradeoff**: Did not use go_router extensively despite being in dependencies; kept simple with built-in navigation for this app size.

### API Integration
- Direct HTTP calls using the `http` package.
- Cached network images with `cached_network_image` for performance.
- **Decision**: No local caching beyond image caching; relies on API for data freshness.

### UI/UX
- Material Design 3 with custom colors (primary: orange tones).
- Responsive layout with SafeArea and padding.
- Loading animations and error states for better UX.

## Approximate Time Spent

- Initial setup and project structure: 2 hours
- API integration and models: 3 hours
- State management with Riverpod: 4 hours
- UI screens and widgets: 5 hours
- Testing and refinements: 2 hours
- **Total**: Approximately 16 hours

## Assumptions and Tradeoffs

### Assumptions
- TheMealDB API is reliable and free; no rate limiting issues assumed.
- Users have internet access for recipe data.
- App targets mobile devices (Android/iOS); web support is secondary.
- No user authentication needed, as the API is public.

### Tradeoffs
- **State Management Simplicity**: Riverpod adds some boilerplate but ensures scalability; for a smaller app, setState could suffice but was avoided for consistency.
- **No Offline Support**: Recipes are fetched on-demand; added complexity for caching would increase development time.
- **Limited Error Handling**: Basic error messages; more robust handling (e.g., retry logic) could be added but prioritized core features.
- **Dependencies**: Kept minimal; shared_preferences is included but not fully utilized (e.g., for favorites persistence could be enhanced).
- **Navigation**: Simple routing; for larger apps, a dedicated router like go_router would be better, but kept lightweight.
- **Performance**: Image caching helps, but large lists could benefit from pagination (not implemented to keep scope small).
