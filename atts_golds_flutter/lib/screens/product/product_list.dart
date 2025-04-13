import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import 'add_product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: FutureBuilder(
        future: productProvider.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          return Consumer<ProductProvider>(
            builder: (context, provider, _) => ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (ctx, i) {
                final product = provider.products[i];

                return ProductCard(
                  product: product,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddProductScreen(existingProduct: product),
                      ),
                    );
                  },
                  onDelete: () {
                    // Optional: Confirm before deleting
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Delete Product'),
                        content: Text('Are you sure you want to delete ${product.name}?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              productProvider.deleteProduct(product.id);
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
