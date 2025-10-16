import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category.dart' as models;

class CategoryService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/categories';

  static Future<List<models.Category>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => models.Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }

  static Future<models.Category?> getCategoryById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return models.Category.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error loading category: $e');
    }
  }

  static Future<models.Category> createCategory(models.Category category) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return models.Category.fromJson(jsonData);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to create category: ${errorBody['message'] ?? response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  static Future<models.Category> updateCategory(int id, models.Category category) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return models.Category.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to update category: ${errorBody['message'] ?? response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  static Future<void> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204) {
        if (response.statusCode == 404) {
          throw Exception('Category not found');
        } else {
          throw Exception('Failed to delete category: ${response.statusCode}');
        }
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }

  static Future<List<models.Category>> searchCategoriesByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?name=${Uri.encodeQueryComponent(name)}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => models.Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search categories: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error searching categories: $e');
    }
  }
}
