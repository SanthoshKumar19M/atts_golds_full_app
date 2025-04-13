import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/billing_provider.dart';
import '../models/customer_model.dart';

void showProductDialog(
  BuildContext context,
  ProductProvider productProvider,
  CustomerModel? selectedCustomer,
) {
  showDialog(
    context: context,
    builder: (ctx) {
      List filteredProducts = productProvider.products;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Select Product"),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search product...",
                      prefixIcon: const Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredProducts = productProvider.products.where((product) => product.name.toLowerCase().contains(value.toLowerCase())).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (ctx, i) {
                        final product = filteredProducts[i];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text("₹ ${product.price} | Tax ${product.tax}%"),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              Provider.of<BillingProvider>(context, listen: false).addToCart(product, selectedCustomer?.name ?? 'Unknown');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
