import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<Map<String, dynamic>> allSales = [];
  List<Map<String, dynamic>> allOrders = [];

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    // Fetch sales data
    final salesSnapshot = await FirebaseFirestore.instance
        .collection('sales') // Replace with your sales collection
        .get();
    final salesData = salesSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // Fetch order history
    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders') // Replace with your orders collection
        .get();
    final ordersData = ordersSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      allSales = salesData;
      allOrders = ordersData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "All Sales",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            allSales.isEmpty
                ? const Center(child: Text("No sales data available"))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allSales.length,
                    itemBuilder: (context, index) {
                      final sale = allSales[index];
                      return Card(
                        child: ListTile(
                          title: Text("Product: ${sale['productName']}"),
                          subtitle: Text(
                              "Quantity Sold: ${sale['quantitySold']}\nTotal: \$${sale['total']}"),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            const Text(
              "All Order History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            allOrders.isEmpty
                ? const Center(child: Text("No order history available"))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allOrders.length,
                    itemBuilder: (context, index) {
                      final order = allOrders[index];
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text("Order ID: ${order['id']}"),
                          subtitle: Text(
                              "User: ${order['userId']}\nTotal: \$${order['total']}"),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
