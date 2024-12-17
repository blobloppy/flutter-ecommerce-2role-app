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
    return {'name': name, 'quantity': quantity, 'price': price};
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
