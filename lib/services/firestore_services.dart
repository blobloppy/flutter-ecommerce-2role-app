import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class FirestoreService {
  final CollectionReference _inventoryCollection =
      FirebaseFirestore.instance.collection('inventory');

  final CollectionReference _activityLogCollection =
      FirebaseFirestore.instance.collection('activity_logs');

  // Add Item and log activity
  Future<void> addItem(InventoryItem item) async {
    // Add item to inventory
    await _inventoryCollection.add({
      'id': item.id,
      'name': item.name,
      'quantity': item.quantity,
      'price': item.price,
      'imageUrl': item.imageUrl,
    });

    // Log activity
    await addActivityLog('Added product', 'Added product: ${item.name}');
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

  // Update Item and log activity
  Future<void> updateItem(InventoryItem item) async {
    await _inventoryCollection.doc(item.id).update(item.toMap());

    // Log activity
    await addActivityLog('Updated product', 'Updated product: ${item.name}');
  }

  // Delete Item and log activity
  Future<void> deleteItem(String id, String itemName) async {
    await _inventoryCollection.doc(id).delete();

    // Log activity
    await addActivityLog('Deleted product', 'Deleted product: $itemName');
  }

  // Add Activity Log
  Future<void> addActivityLog(String action, String details) async {
    try {
      await _activityLogCollection.add({
        'action': action,
        'timestamp': FieldValue.serverTimestamp(),
        'details': details,
      });
    } catch (e) {
      print("Error adding activity log: $e");
    }
  }

  // Fetch Activity Logs
  Stream<List<ActivityLog>> getActivityLogs() {
    return _activityLogCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ActivityLog.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
