import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heavy_rental_app/pages/cart_page.dart';
import 'package:heavy_rental_app/services/firestore_services.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final FirestoreService firestoreService = FirestoreService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  List<InventoryItem> allItems = [];
  List<InventoryItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    firestoreService.getItems().listen((items) {
      setState(() {
        allItems = items;
        filteredItems = items;
      });
    });
  }

  Future<void> _addToCart(InventoryItem item) async {
  print('Adding to cart: ${item.id}, ${item.name}');

  final cartRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .doc(item.id);

  // Check if the product already exists in the cart
  final cartSnapshot = await cartRef.get();

  if (cartSnapshot.exists) {
    // Increment the quantity in the cart
    final currentQuantity = cartSnapshot.data()?['quantity'] ?? 0;
    await cartRef.update({'quantity': currentQuantity + 1});
  } else {
    // Add the product to the cart with an initial quantity of 1
    await cartRef.set({
      'id': item.id,
      'name': item.name,
      'imageUrl': item.imageUrl,
      'quantity': 1,
      'price': item.price,
    });
  }

  print('Decreasing quantity of inventory item: ${item.id}');

  // Decrease the quantity in the inventory
  if (item.quantity > 0) {
    await FirebaseFirestore.instance
        .collection('inventory')
        .doc(item.id)
        .update({'quantity': FieldValue.increment(-1)});
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Out of stock!')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: filteredItems.isEmpty
          ? const Center(
              child: Text("No products available"),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Two items per row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      item.imageUrl.isNotEmpty
                          ? Image.network(
                              item.imageUrl,
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 100),
                      const SizedBox(height: 8),
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("\$${item.price.toStringAsFixed(2)}"),
                      const SizedBox(height: 4),
                      Text("Qty: ${item.quantity}"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _addToCart(item),
                        child: const Text("Add to Cart"),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
