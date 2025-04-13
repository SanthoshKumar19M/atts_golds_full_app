import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer_model.dart';
import '../providers/billing_provider.dart';

class CustomerDropdown extends StatelessWidget {
  final CustomerModel? selectedCustomer;
  final Function(CustomerModel?) onChanged;

  const CustomerDropdown({super.key, required this.selectedCustomer, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<BillingProvider>(context).customers;

    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(30)),
      child: DropdownButtonFormField<CustomerModel>(
        value: selectedCustomer,
        hint: const Text("Select customer"),
        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: InputBorder.none),
        items: customers.map((cust) => DropdownMenuItem(value: cust, child: Text(cust.name))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
