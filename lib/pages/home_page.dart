import 'package:flutter/material.dart';
import 'package:heavy_rental_app/pages/activity_log.dart';
import 'package:heavy_rental_app/pages/edit_products.dart';
import 'package:heavy_rental_app/services/firestore_services.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();

  String searchQuery = "";
  int? minQuantity;
  int? maxQuantity;
  double? minPrice;
  double? maxPrice;

  String sortOption = "Name (A-Z)";

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
        _sortItems(); // Sort items by default
      });
    });
  }

  void _filterItems() {
    setState(() {
      filteredItems = allItems.where((item) {
        final matchesSearch = searchQuery.isEmpty ||
            item.name.toLowerCase().contains(searchQuery.toLowerCase());

        final matchesQuantity =
            (minQuantity == null || item.quantity >= minQuantity!) &&
                (maxQuantity == null || item.quantity <= maxQuantity!);

        final matchesPrice = (minPrice == null || item.price >= minPrice!) &&
            (maxPrice == null || item.price <= maxPrice!);

        return matchesSearch && matchesQuantity && matchesPrice;
      }).toList();
      _sortItems(); // Ensure filtered items are sorted
    });
  }

  void _sortItems() {
    setState(() {
      if (sortOption == "Name (A-Z)") {
        filteredItems.sort((a, b) => a.name.compareTo(b.name));
      } else if (sortOption == "Name (Z-A)") {
        filteredItems.sort((a, b) => b.name.compareTo(a.name));
      } else if (sortOption == "Quantity (Low to High)") {
        filteredItems.sort((a, b) => a.quantity.compareTo(b.quantity));
      } else if (sortOption == "Quantity (High to Low)") {
        filteredItems.sort((a, b) => b.quantity.compareTo(a.quantity));
      } else if (sortOption == "Price (Low to High)") {
        filteredItems.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortOption == "Price (High to Low)") {
        filteredItems.sort((a, b) => b.price.compareTo(a.price));
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Items"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Min Quantity"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  minQuantity = int.tryParse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Max Quantity"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  maxQuantity = int.tryParse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Min Price"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  minPrice = double.tryParse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Max Price"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  maxPrice = double.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterItems();
                  Navigator.pop(context);
                });
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortOption = value;
                _sortItems(); // Re-sort items on selection
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: "Name (A-Z)", child: Text("Name (A-Z)")),
              const PopupMenuItem(
                  value: "Name (Z-A)", child: Text("Name (Z-A)")),
              const PopupMenuItem(
                  value: "Quantity (Low to High)",
                  child: Text("Quantity (Low to High)")),
              const PopupMenuItem(
                  value: "Quantity (High to Low)",
                  child: Text("Quantity (High to Low)")),
              const PopupMenuItem(
                  value: "Price (Low to High)",
                  child: Text("Price (Low to High)")),
              const PopupMenuItem(
                  value: "Price (High to Low)",
                  child: Text("Price (High to Low)")),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to the Activity Log screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivityLogScreen(),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search items...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterItems();
                });
              },
            ),
          ),
        ),
      ),
      body: filteredItems.isEmpty
          ? const Center(child: Text("No items match the criteria."))
          : ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  leading: item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 50),
                  title: Text(item.name),
                  subtitle:
                      Text("Qty: ${item.quantity} | Price: \$${item.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditItemScreen(item: item),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            firestoreService.deleteItem(item.id, item.name),
                      ),
                    ],
                  ),
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
