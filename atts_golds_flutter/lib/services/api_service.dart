import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/global_config.dart';
import '../models/bill_model.dart';
import '../models/product_model.dart';

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:5000/api';
  // static const String baseUrl = 'http://localhost:5000/api';
  static const String baseUrl = GlobalConfig.baseUrl;

  // GET Products
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  // POST Product
  static Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add product');
    }
  }

  // PUT Product
  static Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  // DELETE Product
  static Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

// SAVE BILL TO BACKEND
  static Future<String> saveBill(List<BillItem> items, double total, String selectedCustomer) async {
    List<Map<String, dynamic>> billData = items.map((e) {
      return {
        "product": {
          "name": e.product.name,
          "price": e.product.price,
          "tax": e.product.tax,
          "discount": e.product.discount,
          "quantity": e.quantity,
        },
        "totalPrice": e.totalPrice,
      };
    }).toList();

    final data = {
      "items": billData,
      "customerName": selectedCustomer,
      "totalAmount": total,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bills'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode != 201) {
        print("Failed response: ${response.body}");
        throw Exception("Failed to save bill");
      } else {
        final decoded = jsonDecode(response.body);
        print("Bill saved successfully");
        print(decoded['invoiceNumber']);
        return decoded['invoiceNumber']; // ✅ Extract and return invoice number
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception("Failed to save bill due to network error");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchBills() async {
    final response = await http.get(Uri.parse('$baseUrl/bills'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load bills');
    }
  }
}
