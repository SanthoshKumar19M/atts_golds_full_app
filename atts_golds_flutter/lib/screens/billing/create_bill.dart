import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/billing_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_button.dart';
import '../../utils/pdf_invoice.dart';
import '../../widgets/customer_dropdown.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/total_amount_text.dart';
import '../../widgets/product_dialog.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  late Future<void> _initDataFuture;
  CustomerModel? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _initDataFuture = _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    await Provider.of<BillingProvider>(context, listen: false).fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final billingProvider = Provider.of<BillingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Bill'), leading: const BackButton()),
      body: FutureBuilder(
        future: _initDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomerDropdown(
                        selectedCustomer: _selectedCustomer,
                        onChanged: (cust) => setState(() => _selectedCustomer = cust),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: "Add products",
                        icon: Icons.add,
                        color: Colors.blueGrey[400],
                        onPressed: () => showProductDialog(context, productProvider, _selectedCustomer),
                      ),
                    ),
                  ],
                ),
              ),
              const Text("Cart Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  color: Colors.yellow[200],
                  child: billingProvider.items.isEmpty
                      ? const Center(child: Text("Add products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                      : ListView.builder(
                          itemCount: billingProvider.items.length,
                          itemBuilder: (ctx, i) => CartItemCard(item: billingProvider.items[i]),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              TotalAmountText(total: billingProvider.totalAmount),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: "Save",
                  onPressed: () async {
                    if (_selectedCustomer == null || billingProvider.items.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Select customer & add products")),
                      );
                      return;
                    }

                    final invoiceNumber = await ApiService.saveBill(
                      billingProvider.items,
                      billingProvider.totalAmount,
                      _selectedCustomer!.name,
                    );

                    await PDFInvoice.generateInvoice(
                      billingProvider.items,
                      billingProvider.totalAmount,
                      _selectedCustomer!.name,
                      invoiceNumber,
                    );

                    billingProvider.clearCart();
                    setState(() => _selectedCustomer = null);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invoice created successfully")),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
