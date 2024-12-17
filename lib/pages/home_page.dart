import 'package:flutter/material.dart';
import 'package:heavy_rental_app/services/firestore_services.dart';
import 'package:heavy_rental_app/services/product_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text("Inventory Management")),
      body: StreamBuilder<List<InventoryItem>>(
        stream: firestoreService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Stream Error: ${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No items in inventory."));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle:
                    Text("Qty: ${item.quantity} | Price: \$${item.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => firestoreService.deleteItem(item.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addItem');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
