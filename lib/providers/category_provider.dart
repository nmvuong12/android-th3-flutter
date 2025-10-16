import 'package:flutter/foundation.dart';
import '../models/category.dart' as models;
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  List<models.Category> _categories = [];
  List<models.Category> _filteredCategories = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<models.Category> get categories => _categories;
  List<models.Category> get filteredCategories => _filteredCategories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await CategoryService.getAllCategories();
      _applyFilter();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new category
  Future<void> createCategory(models.Category category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newCategory = await CategoryService.createCategory(category);
      _categories.add(newCategory);
      _applyFilter();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update category
  Future<void> updateCategory(int id, models.Category category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedCategory = await CategoryService.updateCategory(id, category);
      final index = _categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categories[index] = updatedCategory;
        _applyFilter();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await CategoryService.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      _applyFilter();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search categories by name
  Future<void> searchCategories(String query) async {
    _searchQuery = query;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _filteredCategories = List.from(_categories);
      } else {
        _filteredCategories = await CategoryService.searchCategoriesByName(query);
      }
    } catch (e) {
      _error = e.toString();
      _filteredCategories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _applyFilter();
  }

  // Apply local filter (for when we have all categories loaded)
  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredCategories = List.from(_categories);
    } else {
      _filteredCategories = _categories
          .where((category) =>
              category.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  // Get category by ID
  models.Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await loadCategories();
  }
}
