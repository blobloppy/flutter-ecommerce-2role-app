import 'package:flutter/material.dart';

class VehicleDetailPage extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  VehicleDetailPage({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vehicle['name'] ?? 'Vehicle Detail',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(vehicle['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Vehicle Details
            Text(
              vehicle['name'] ?? 'Unknown',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              vehicle['model'] ?? 'Unknown Model',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 10),
            // Pricing Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Price", style: TextStyle(fontSize: 16)),
                Text(
                  'Rp.${vehicle['price'] ?? '0'}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Weight (kg)", style: TextStyle(fontSize: 16)),
                Text(
                  '${vehicle['weight'] ?? '0'}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Height (m)", style: TextStyle(fontSize: 16)),
                Text(
                  '${vehicle['height'] ?? '0'}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Width", style: TextStyle(fontSize: 16)),
                Text(
                  '${vehicle['width'] ?? '0'}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            // Add your rental logic here
            print('Rental button pressed for ${vehicle['name']}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Rental Appointment Has Been Ordered"),
                duration: Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Rent Now',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
