import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'product/product_list.dart';
import 'product/add_product.dart';
import 'billing/create_bill.dart';
import 'billing/billing_history.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> sections = [
    {'title': 'Products', 'icon': Icons.inventory_2_outlined, 'screen': ProductListScreen()},
    {'title': 'Add Product', 'icon': Icons.add_box_outlined, 'screen': AddProductScreen()},
    {'title': 'Create Bill', 'icon': Icons.receipt_long, 'screen': CreateBillScreen()},
    {'title': 'Sale bills', 'icon': Icons.history, 'screen': BillingHistoryScreen()},
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user?.username;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Reduced height
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)), // Slightly smaller curve
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade700, Colors.amber.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            centerTitle: true,
            elevation: 8,
            backgroundColor: Colors.transparent,
            title: Text(
              'ATTS Gold',
              style: TextStyle(
                fontSize: 22, // Reduced font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1.5),
                    blurRadius: 2,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.currency_exchange, size: 32, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'ATTS GOLDS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, ${userName ?? "---"}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(context, 'Home', Icons.home_outlined, HomeScreen()),
            _buildDrawerItem(context, 'Products', Icons.inventory_2_outlined, ProductListScreen()),
            _buildDrawerItem(context, 'Add Product', Icons.add_box_outlined, AddProductScreen()),
            _buildDrawerItem(context, 'Create Bill', Icons.receipt_long, CreateBillScreen()),
            _buildDrawerItem(context, 'Sale Bills', Icons.history, BillingHistoryScreen()),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: sections.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (ctx, index) {
            final section = sections[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => section['screen']),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.amber[50],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(section['icon'], size: 40, color: Colors.amber[800]),
                    SizedBox(height: 10),
                    Text(
                      section['title'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  ListTile _buildDrawerItem(BuildContext context, String title, IconData icon, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber.shade700),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
    );
  }
}
