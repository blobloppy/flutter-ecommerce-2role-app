import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  InventoryItem(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.quantity,
      required this.price});

  // Convert item to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'id': id,
      'imageUrl': imageUrl
    };
  }

  // Factory to create an item from Firestore map
  factory InventoryItem.fromMap(String id, Map<String, dynamic> map) {
    return InventoryItem(
      id: id,
      name: map['name'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}

class ActivityLog {
  final String action;
  final String details;
  final DateTime timestamp;

  ActivityLog({
    required this.action,
    required this.details,
    required this.timestamp,
  });

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      action: map['action'],
      details: map['details'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
