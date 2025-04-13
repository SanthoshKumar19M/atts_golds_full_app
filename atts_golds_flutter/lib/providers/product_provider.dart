import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    _products = await ApiService.getProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await ApiService.addProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(Product product) async {
    await ApiService.updateProduct(product);
    await fetchProducts();
  }

  Future<void> deleteProduct(String id) async {
    await ApiService.deleteProduct(id);
    await fetchProducts();
  }
}
