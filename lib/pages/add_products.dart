import 'package:flutter/material.dart';
import 'package:heavy_rental_app/services/firestore_services.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      final newItem = InventoryItem(
        id: "", // Firestore generates this automatically
        name: nameController.text,
        quantity: int.parse(quantityController.text),
        price: double.parse(priceController.text),
        imageUrl: imageUrlController.text,
      );

      await firestoreService.addItem(newItem);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Item Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter an item name" : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantity"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a quantity" : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a price" : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: "Image URL"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter an image URL" : null,
              ),
              SizedBox(
                height: 20,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addItem,
                child: const Text("Add Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
