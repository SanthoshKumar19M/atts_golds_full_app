class Product {
  final String id;
  final String name;
  final double price;
  final double tax;
  final double discount;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['_id'],
        name: json['name'],
        price: (json['price'] ?? 0).toDouble(),
        tax: (json['tax'] ?? 0).toDouble(),
        discount: (json['discount'] ?? 0).toDouble(),
        category: json['category'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'tax': tax,
        'discount': discount,
        'category': category,
      };
}
