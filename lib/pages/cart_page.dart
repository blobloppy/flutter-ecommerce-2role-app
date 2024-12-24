import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  Future<void> checkout(BuildContext context) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch cart items
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      final cartItems = cartSnapshot.docs.map((doc) {
        return CartItem.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      // Calculate total price
      double total =
          cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

      // Create a new order
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      final orderId = orderRef.id; // Generate a unique ID for the order

      await orderRef.set({
        'id': orderId, // Ensure 'id' is saved
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'total': total, // Ensure 'total' is calculated and saved
        'items': cartItems.map((item) => item.toMap()).toList(),
      });

      // Clear the user's cart
      for (var item in cartSnapshot.docs) {
        await item.reference.delete();
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkout successful!')),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs
              .map((doc) =>
                  CartItem.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList();

          if (cartItems.isEmpty) {
            return const Center(
              child: Text("Your cart is empty!"),
            );
          }

          // Calculate total price
          double totalPrice = cartItems.fold(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return ListTile(
                      leading:
                          Image.network(item.imageUrl, width: 50, height: 50),
                      title: Text(item.name),
                      subtitle: Text(
                          "Qty: ${item.quantity} | \$${item.price * item.quantity}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await cartRef.doc(item.id).delete();
                          final inventoryRef = FirebaseFirestore.instance
                              .collection('inventory')
                              .doc(item.id);
                          await inventoryRef.update({
                            'quantity': FieldValue.increment(item.quantity),
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Total: \$${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => checkout(context),
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
