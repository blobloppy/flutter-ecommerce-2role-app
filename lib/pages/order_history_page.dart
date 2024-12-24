import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ordersRef = FirebaseFirestore.instance.collection('orders');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ordersRef
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Log the error in the terminal
            print("Error fetching order history: ${snapshot.error}");
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No order history available."),
            );
          }

          final orders = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final List<dynamic> items =
                  order['items'] ?? []; // List of items in the order

              return Card(
                color: Colors.white,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${order['id']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "Total: \$${order['total']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Items:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, itemIndex) {
                          final item = items[itemIndex];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.network(
                              item['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['name']),
                            subtitle: Text(
                                "Qty: ${item['quantity']} | \$${item['price']}"),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Date: ${order['timestamp'].toDate()}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
