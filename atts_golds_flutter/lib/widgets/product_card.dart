import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Colors.amber.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/images/gold_demo.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.brown[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Price: ₹${product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.brown[600]),
                  ),
                  Text(
                    'Tax: ${product.tax}% | Discount: ${product.discount}%',
                    style: TextStyle(color: Colors.brown[600]),
                  ),
                ],
              ),
            ),

            // Divider and action buttons
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.blueAccent),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_outlined, color: Colors.redAccent),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
