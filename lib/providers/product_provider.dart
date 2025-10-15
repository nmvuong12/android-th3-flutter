import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  double? _minPrice;
  double? _maxPrice;

  // Getters
  List<Product> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;

  // Khởi tạo - Load tất cả sản phẩm
  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();
    
    try {
      _products = await ProductService.getAllProducts();
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError('Lỗi khi tải danh sách sản phẩm: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Lấy sản phẩm theo ID
  Future<Product?> getProductById(int id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final product = await ProductService.getProductById(id);
      _setLoading(false);
      return product;
    } catch (e) {
      _setError('Lỗi khi tải sản phẩm: $e');
      _setLoading(false);
      return null;
    }
  }

  // Tạo sản phẩm mới
  Future<bool> createProduct(Product product) async {
    _setLoading(true);
    _clearError();
    
    try {
      final newProduct = await ProductService.createProduct(product);
      _products.add(newProduct);
      _applyFilters();
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Lỗi khi tạo sản phẩm: $e');
      _setLoading(false);
      return false;
    }
  }

  // Cập nhật sản phẩm
  Future<bool> updateProduct(Product product) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedProduct = await ProductService.updateProduct(product.id, product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        _applyFilters();
        notifyListeners();
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Lỗi khi cập nhật sản phẩm: $e');
      _setLoading(false);
      return false;
    }
  }

  // Xóa sản phẩm
  Future<bool> deleteProduct(int id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await ProductService.deleteProduct(id);
      if (success) {
        _products.removeWhere((p) => p.id == id);
        _applyFilters();
        notifyListeners();
      }
      _setLoading(false);
      return success;
    } catch (e) {
      _setError('Lỗi khi xóa sản phẩm: $e');
      _setLoading(false);
      return false;
    }
  }

  // Tìm kiếm sản phẩm theo tên
  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _applyFilters();
      return;
    }

    _setLoading(true);
    _clearError();
    
    try {
      final searchResults = await ProductService.searchProductsByName(query);
      _filteredProducts = searchResults;
      notifyListeners();
    } catch (e) {
      _setError('Lỗi khi tìm kiếm sản phẩm: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Lọc sản phẩm theo khoảng giá
  Future<void> filterProductsByPriceRange(double? minPrice, double? maxPrice) async {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    
    if (minPrice == null && maxPrice == null) {
      _applyFilters();
      return;
    }

    _setLoading(true);
    _clearError();
    
    try {
      final filteredResults = await ProductService.getProductsByPriceRange(
        minPrice ?? 0.0,
        maxPrice ?? double.infinity,
      );
      _filteredProducts = filteredResults;
      notifyListeners();
    } catch (e) {
      _setError('Lỗi khi lọc sản phẩm theo giá: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Xóa tất cả bộ lọc
  void clearFilters() {
    _searchQuery = '';
    _minPrice = null;
    _maxPrice = null;
    _filteredProducts.clear();
    notifyListeners();
  }

  // Áp dụng các bộ lọc hiện tại
  void _applyFilters() {
    _filteredProducts.clear();
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await loadProducts();
  }
}
