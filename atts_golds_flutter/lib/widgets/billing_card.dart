import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingCard extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillingCard({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.parse(bill['createdAt']);

    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.amber[50],
      shadowColor: Colors.amber[200],
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        collapsedIconColor: Colors.amber[800],
        iconColor: Colors.amber[900],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice: ${bill['invoiceNumber'] ?? '---'}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown[800]),
            ),
            Text(
              'Customer: ${bill['customerName'] ?? '---'}',
              style: TextStyle(fontSize: 14, color: Colors.brown[600]),
            ),
          ],
        ),
        subtitle: Text(
          'Total: ₹${bill['totalAmount']} • ${DateFormat('dd MMM yyyy hh:mm a').format(createdAt)}',
          style: TextStyle(color: Colors.brown[500]),
        ),
        children: List.generate(bill['items'].length, (i) {
          final item = bill['items'][i];
          final product = item['product'];

          return Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.amber.shade200)),
            ),
            child: ListTile(
              title: Text(product['name'], style: TextStyle(color: Colors.brown[800])),
              subtitle: Text(
                'Qty: ${product['quantity']}, Tax: ${product['tax']}%, Discount: ${product['discount']}%, Category: ${product['category'] ?? 'N/A'}',
                style: TextStyle(fontSize: 12, color: Colors.brown[600]),
              ),
              trailing: Text('₹${item['totalPrice']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
            ),
          );
        }),
      ),
    );
  }
}
