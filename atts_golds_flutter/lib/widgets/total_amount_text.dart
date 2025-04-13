import 'package:flutter/material.dart';

class TotalAmountText extends StatelessWidget {
  final double total;
  const TotalAmountText({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Total: ₹ ${total.toStringAsFixed(2)}",
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}
