import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/api_service.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final apiService = ApiService();
  return await apiService.getCategories();
});
