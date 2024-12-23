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

class CartItem {
  final String id; // Product ID
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  // Convert CartItem to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }

  // Factory to create a CartItem from Firestore map
  factory CartItem.fromMap(String id, Map<String, dynamic> map) {
    return CartItem(
      id: id,
      name: map['name'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  // Convert Order to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Factory to create an Order from Firestore map
  factory Order.fromMap(String id, Map<String, dynamic> map) {
    return Order(
      id: id,
      userId: map['userId'],
      items: (map['items'] as List<dynamic>)
          .map((item) => CartItem.fromMap('', item))
          .toList(),
      totalAmount: map['totalAmount'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
