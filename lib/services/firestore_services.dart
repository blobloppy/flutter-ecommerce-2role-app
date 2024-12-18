import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class FirestoreService {
  final CollectionReference _inventoryCollection =
      FirebaseFirestore.instance.collection('inventory');

  // Add Item
  Future<void> addItem(InventoryItem item) async {
    await FirebaseFirestore.instance.collection('inventory').add({
      'id': item.id,
      'name': item.name,
      'quantity': item.quantity,
      'price': item.price,
      'imageUrl': item.imageUrl,
    });
  }

  // Fetch All Items
  Stream<List<InventoryItem>> getItems() {
    return _inventoryCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return InventoryItem.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update Item
  Future<void> updateItem(InventoryItem item) async {
    await _inventoryCollection.doc(item.id).update(item.toMap());
  }

  // Delete Item
  Future<void> deleteItem(String id) async {
    await _inventoryCollection.doc(id).delete();
  }
}
