import 'package:flutter/material.dart';
import 'package:heavy_rental_app/services/firestore_services.dart';
import 'package:heavy_rental_app/services/product_model.dart';

class EditItemScreen extends StatefulWidget {
  final InventoryItem item;

  const EditItemScreen({Key? key, required this.item}) : super(key: key);

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    // Pre-fill the controllers with existing item data
    _nameController = TextEditingController(text: widget.item.name);
    _imageUrlController = TextEditingController(text: widget.item.imageUrl);
    _quantityController =
        TextEditingController(text: widget.item.quantity.toString());
    _priceController =
        TextEditingController(text: widget.item.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateItem() {
    if (_formKey.currentState!.validate()) {
      final updatedItem = InventoryItem(
        id: widget.item.id,
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
      );

      // Update the item in Firestore
      _firestoreService.updateItem(updatedItem);

      // Navigate back to the Home Screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Item Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter item name" : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter quantity" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter price" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateItem,
                child: const Text("Update Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
