import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/billing_provider.dart';
// import '../models/billing_item.dart';
import '../models/bill_model.dart';

class CartItemCard extends StatelessWidget {
  final BillItem item;
  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final billingProvider = Provider.of<BillingProvider>(context, listen: false);

    return Dismissible(
      key: Key(item.product.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        billingProvider.removeFromCart(item.product.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${item.product.name} removed from cart")));
      },
      background: Container(
        color: Colors.red[100],
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Card(
        color: Colors.blue.shade50,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          title: Text(item.product.name),
          subtitle: Text("Tax ${item.product.tax}% | ₹ ${item.product.price} | Dis ${item.product.discount}%"),
          trailing: SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    billingProvider.decreaseQuantity(item.product.id);
                    if (item.quantity <= 1) billingProvider.removeFromCart(item.product.id);
                  },
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => billingProvider.increaseQuantity(item.product.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
