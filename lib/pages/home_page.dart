import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heavy_rental_app/pages/detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> models = [
    "All",
    "Excavator",
    "Bulldozer",
    "Crane",
    "Wheel Loader"
  ];
  String selectedModel = "All";
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fetch vehicles based on the selected category and search query
  Future<List<Map<String, dynamic>>> fetchVehicles() async {
    try {
      Query query = FirebaseFirestore.instance.collection('heavy_vehicles');

      if (selectedModel != "All") {
        query = query.where('model', isEqualTo: selectedModel);
      }

      if (searchQuery.isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff');
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching vehicles: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Rental',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: "Search vehicles...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // Category Selector
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: models.length,
              itemBuilder: (context, index) {
                final model = models[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedModel = model;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          selectedModel == model ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        model,
                        style: TextStyle(
                          color: selectedModel == model
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Vehicle List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchVehicles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                final vehicles = snapshot.data ?? [];
                if (vehicles.isEmpty) {
                  return Center(
                    child: Text(
                      'No vehicles found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: vehicles.length,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Placeholder Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                            ),
                            child: Icon(Icons.image,
                                size: 40, color: Colors.grey[700]),
                          ),
                          SizedBox(width: 16),
                          // Vehicle Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicle['name'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Price: Rp.${vehicle['price'] ?? '0'}/hour',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // See Details Button
                          ElevatedButton(
                            onPressed: () {
                              // Implement navigation to a detail page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VehicleDetailPage(vehicle: vehicle)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'See Detail',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
