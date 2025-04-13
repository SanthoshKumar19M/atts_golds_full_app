import 'package:flutter/material.dart';
import '../models/bill_model.dart';

class BillingProvider with ChangeNotifier {
  List<BillItem> _items = [];

  List<BillItem> get items => _items;

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addItem(BillItem item) {
    int index = _items.indexWhere((i) => i.product.id == item.product.id);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int qty) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity = qty;
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
