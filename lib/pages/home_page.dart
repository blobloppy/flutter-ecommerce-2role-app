import 'package:firebase_auth/firebase_auth.dart';
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

        return matchesSearch && matchesQuantity;
      }).toList();
      _sortItems();
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
                _sortItems();
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
            ],
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivityLogScreen(),
                ),
              );
            },
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 50.0,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "No products found. Add your first product!",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Change to 1 item per row for bigger cards
                crossAxisSpacing: 16.0, // Increase spacing between items
                mainAxisSpacing: 16.0, // Increase vertical spacing
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      item.imageUrl.isNotEmpty
                          ? Container(
                              color: Colors.grey[200], // Subtle color accent
                              child: Image.network(
                                item.imageUrl,
                                height: 230.0, // Increased image height
                                width: 230.0, // Increased image width
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image,
                              size: 100), // Larger default icon
                      const SizedBox(height: 12),
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Slightly larger font size
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Qty: ${item.quantity}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.teal, // Contrasting color
                        ),
                      ),
                      // ... Action buttons row
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Center buttons
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditItemScreen(item: item),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => firestoreService.deleteItem(
                                  item.id, item.name),
                            ),
                          ],
                        ),
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
