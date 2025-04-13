import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../utils/pdf_invoice.dart';
import '../../widgets/billing_card.dart';

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({super.key});

  @override
  _BillingHistoryScreenState createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  List<Map<String, dynamic>> allBills = [];
  List<Map<String, dynamic>> filteredBills = [];

  String searchQuery = '';
  String sortBy = 'date_desc';
  String selectedCategory = 'All';

  int currentPage = 0;
  final int itemsPerPage = 20;

  List<String> allCategories = ['All'];

  @override
  void initState() {
    super.initState();
    fetchBills();
  }

  void fetchBills() async {
    try {
      final bills = await ApiService.fetchBills();

      // Extract categories from the product items
      final categories = <String>{'All'};
      for (var bill in bills) {
        for (var item in bill['items']) {
          final category = item['product']['category'] ?? '';
          if (category.isNotEmpty) categories.add(category);
        }
      }

      setState(() {
        allBills = bills;
        allCategories = categories.toList();
        applyFilters();
      });
    } catch (e) {
      print('Error fetching bills: $e');
    }
  }

  void applyFilters() {
    List<Map<String, dynamic>> result = allBills.where((bill) {
      final customer = bill['customerName'].toString().toLowerCase();
      final invoice = bill['invoiceNumber'].toString().toLowerCase();
      final matchesSearch = customer.contains(searchQuery.toLowerCase()) || invoice.contains(searchQuery.toLowerCase()); // 👈 also match invoiceNumber

      if (selectedCategory != 'All') {
        final hasCategory = bill['items'].any(
          (item) => item['product']['category'] == selectedCategory,
        );
        return matchesSearch && hasCategory;
      }

      return matchesSearch;
    }).toList();

    // Apply sorting
    if (sortBy == 'date_desc') {
      result.sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
    } else if (sortBy == 'amount_asc') {
      result.sort((a, b) => a['totalAmount'].compareTo(b['totalAmount']));
    } else if (sortBy == 'amount_desc') {
      result.sort((a, b) => b['totalAmount'].compareTo(a['totalAmount']));
    }

    setState(() {
      filteredBills = result;
      currentPage = 0; // Reset to first page
    });
  }

  List<Map<String, dynamic>> getPaginatedBills() {
    final start = currentPage * itemsPerPage;
    final end = (start + itemsPerPage) > filteredBills.length ? filteredBills.length : start + itemsPerPage;
    return filteredBills.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final displayedBills = getPaginatedBills();

    return Scaffold(
      appBar: AppBar(title: Text('Billing History')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by Customer...',
                        prefixIcon: Icon(Icons.search, color: Colors.amber[800]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      ),
                      onChanged: (value) {
                        searchQuery = value;
                        applyFilters();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // SizedBox(width: 8),
                // IconButton(
                //   icon: Icon(Icons.filter_list),
                //   // onPressed: () => _showFilterDialog(context),
                //   // onPressed: (){
                //   // await PDFInvoice.generateInvoice(
                //   //   billingProvider.items,
                //   //   billingProvider.totalAmount,
                //   //   _selectedCustomer!.name,
                //   //   invoiceNumber,
                //   // );}
                // ),
                IconButton(
                  icon: Icon(Icons.sort, color: Colors.amber[800]),
                  onPressed: () => _showSortDialog(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedBills.isEmpty
                ? Center(child: Text('No bills found'))
                : ListView.builder(
                    itemCount: displayedBills.length,
                    itemBuilder: (context, index) {
                      final bill = displayedBills[index];
                      final createdAt = DateTime.parse(bill['createdAt']);
                      return BillingCard(bill: bill);
                    },
                  ),
          ),
          if (filteredBills.length > itemsPerPage)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.amber[800]),
                    onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
                  ),
                  Text('${currentPage + 1} / ${(filteredBills.length / itemsPerPage).ceil()}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.amber[800]),
                    onPressed: currentPage < (filteredBills.length / itemsPerPage - 1) ? () => setState(() => currentPage++) : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sort by'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Date (Newest First)'),
              value: 'date_desc',
              groupValue: sortBy,
              onChanged: (val) {
                Navigator.pop(context);
                setState(() {
                  sortBy = val!;
                  applyFilters();
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Amount (Low to High)'),
              value: 'amount_asc',
              groupValue: sortBy,
              onChanged: (val) {
                Navigator.pop(context);
                setState(() {
                  sortBy = val!;
                  applyFilters();
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Amount (High to Low)'),
              value: 'amount_desc',
              groupValue: sortBy,
              onChanged: (val) {
                Navigator.pop(context);
                setState(() {
                  sortBy = val!;
                  applyFilters();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // void _showFilterDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text('Filter by Category'),
  //       content: DropdownButton<String>(
  //         value: selectedCategory,
  //         isExpanded: true,
  //         items: allCategories
  //             .map((cat) => DropdownMenuItem(
  //                   value: cat,
  //                   child: Text(cat),
  //                 ))
  //             .toList(),
  //         onChanged: (value) {
  //           Navigator.pop(context);
  //           setState(() {
  //             selectedCategory = value!;
  //             applyFilters();
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }
}
