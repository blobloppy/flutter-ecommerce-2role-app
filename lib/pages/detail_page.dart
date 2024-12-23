import 'package:flutter/material.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class DetailPage extends StatelessWidget {
  final InventoryItem item;

  const DetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.imageUrl.isNotEmpty
                ? Image.network(
                    item.imageUrl,
                    height: 250.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.image,
                    size: 100,
                  ),
            const SizedBox(height: 16.0),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Quantity: ${item.quantity}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            // Add more details here if necessary
          ],
        ),
      ),
    );
  }
}
