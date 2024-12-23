import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

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
                          // Remove item from cart
                          await cartRef.doc(item.id).delete();

                          // Increase the quantity back in the inventory
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
                child: Text(
                  "Total: \$${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
