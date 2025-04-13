import 'product_model.dart';

class BillItem {
  final Product product;
  int quantity;
  final String customer;

  BillItem({required this.product, this.quantity = 1, required this.customer});

  double get totalPrice {
    final double base = product.price * quantity;
    final double discountAmount = base * (product.discount / 100);
    final double taxableAmount = base - discountAmount;
    final double taxAmount = taxableAmount * (product.tax / 100);
    return taxableAmount + taxAmount;
  }

  // Convert BillItem to JSON, including the product's toJson method
  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'customer': customer,
        'totalPrice': totalPrice,
      };
}
