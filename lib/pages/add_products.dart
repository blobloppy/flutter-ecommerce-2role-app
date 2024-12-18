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
  final _firestoreService = FirestoreService();

  String _name = "";
  String _id = "";
  String _imageUrl = "";
  int _quantity = 0;
  double _price = 0.0;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newItem = InventoryItem(
          id: _id,
          name: _name,
          quantity: _quantity,
          price: _price,
          imageUrl: _imageUrl);
      _firestoreService.addItem(newItem);
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
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Item ID"),
                onSaved: (value) => _id = value!,
                validator: (value) => value!.isEmpty ? "Enter item id" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Item Name"),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? "Enter item name" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Item Image URL"),
                onSaved: (value) => _imageUrl = value!,
                validator: (value) =>
                    value!.isEmpty ? "Enter item image URL" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _price = double.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text("Save Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
