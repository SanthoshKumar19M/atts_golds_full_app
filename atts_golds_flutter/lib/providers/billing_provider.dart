import 'dart:convert';
import 'package:atts_golds_flutter/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../config/global_config.dart';
import '../models/bill_model.dart';
import '../models/customer_model.dart';

class BillingProvider with ChangeNotifier {
  List<BillItem> _items = [];
  List<BillItem> get items => _items;

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  List<CustomerModel> _customers = [];
  List<CustomerModel> get customers => _customers;

  // static const String baseUrl = 'http://10.0.2.2:5000/api';
  static const String baseUrl = GlobalConfig.baseUrl;

  Future<void> fetchCustomers() async {
    try {
      print("Fetching customers from API...");
      final response = await http.get(Uri.parse('$baseUrl/customers'));

      if (response.statusCode == 200) {
        final List decoded = jsonDecode(response.body);

        _customers = decoded.map((e) => CustomerModel.fromJson(e)).toList();
        print("Customers fetched successfully: ${_customers.length}");
      } else {
        print("Failed to fetch customers. Status code: ${response.statusCode}");
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching customers: $e");
    }
  }

  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1 && _items[index].quantity > 0) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  void addItem(BillItem item) {
    int index = _items.indexWhere((i) => i.product.id == item.product.id);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void addToCart(Product product, String customer) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(BillItem(product: product, customer: customer));
    }
    notifyListeners();
  }

//   void addItemToCart(Product product, int quantity) {
//   final existingItem = _cartItems.firstWhere(
//     (item) => item.product.id == product.id,
//     orElse: () => null,
//   );

//   if (existingItem != null) {
//     existingItem.quantity += quantity;
//   } else {
//     _cartItems.add(CartItem(product: product, quantity: quantity));
//   }

//   notifyListeners();
// }

  void updateQuantity(String productId, int qty) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity = qty;
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
