
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  static const String apiUrl =
      'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData is! List) {
          throw const FormatException('Invalid API response');
        }

        return decodedData.map((item) {
          return Product.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Products not found (404)');
      } else if (response.statusCode == 500) {
        throw Exception('Server error (500)');
      } else {
        throw Exception(
          'Request failed: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception(
        'Connection timeout. Please try again.',
      );
    } on http.ClientException {
      throw Exception(
        'No internet connection. Please check your network.',
      );
    } on FormatException {
      throw Exception(
        'Invalid data received from server.',
      );
    } catch (e) {
      rethrow;
    }
  }
}
