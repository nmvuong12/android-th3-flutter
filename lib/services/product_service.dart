import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../config/api_config.dart';

class ProductService {

  // Lấy danh sách tất cả sản phẩm
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.baseUrl),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Lấy sản phẩm theo ID
  static Future<Product> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/$id'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // Tạo sản phẩm mới
  static Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl),
        headers: ApiConfig.headers,
        body: json.encode(product.toCreateJson()),
      );

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  // Cập nhật sản phẩm
  static Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/$id'),
        headers: ApiConfig.headers,
        body: json.encode(product.toUpdateJson()),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  // Xóa sản phẩm
  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/$id'),
        headers: ApiConfig.headers,
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  // Tìm kiếm sản phẩm theo tên
  static Future<List<Product>> searchProductsByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.buildSearchUrl(name)),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }

  // Lấy sản phẩm theo khoảng giá
  static Future<List<Product>> getProductsByPriceRange(
      double minPrice, double maxPrice) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.buildPriceRangeUrl(minPrice, maxPrice)),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products by price range: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products by price range: $e');
    }
  }
}
