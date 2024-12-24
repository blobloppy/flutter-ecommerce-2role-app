import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heavy_rental_app/pages/cart_page.dart';
import 'package:heavy_rental_app/pages/order_history_page.dart';
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
  String searchQuery = "";

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

  void _filterItems(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredItems = allItems
          .where((item) => item.name.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  Future<void> _addToCart(InventoryItem item) async {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(item.id);

    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.exists) {
      final currentQuantity = cartSnapshot.data()?['quantity'] ?? 0;
      await cartRef.update({'quantity': currentQuantity + 1});
    } else {
      await cartRef.set({
        'id': item.id,
        'name': item.name,
        'imageUrl': item.imageUrl,
        'quantity': 1,
        'price': item.price,
      });
    }

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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderHistoryPage()),
              );
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out the user
              // Optionally, navigate to a login screen or perform other actions
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Search for products",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterItems,
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text("No products available"),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // Two items per row
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.white,
                        elevation: 4.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.imageUrl,
                                    height: 230,
                                    width: 230,
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
          ),
        ],
      ),
    );
  }
}
