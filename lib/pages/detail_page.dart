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
                  image: NetworkImage(vehicle['image_url'] ?? 'https://via.placeholder.com/150'),
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
                Text("Total Harga", style: TextStyle(fontSize: 16)),
                Text(
                  'Rp.${vehicle['price'] ?? '0'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery Fee", style: TextStyle(fontSize: 16)),
                Text(
                  'Rp. 8.000',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Packaging Fee", style: TextStyle(fontSize: 16)),
                Text(
                  'Rp. 3.000',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Utensil", style: TextStyle(fontSize: 16)),
                Text(
                  'Free',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Diskon Promo", style: TextStyle(fontSize: 16)),
                Text(
                  '-Rp. 12.000',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
