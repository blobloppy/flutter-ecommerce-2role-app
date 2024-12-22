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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.item.name;
    quantityController.text = widget.item.quantity.toString();
    priceController.text = widget.item.price.toString();
    imageUrlController.text = widget.item.imageUrl;
  }

  Future<void> _updateItem() async {
    if (_formKey.currentState!.validate()) {
      final updatedItem = InventoryItem(
        id: widget.item.id,
        name: nameController.text,
        quantity: int.parse(quantityController.text),
        price: double.parse(priceController.text),
        imageUrl: imageUrlController.text,
      );

      await firestoreService.updateItem(updatedItem);
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
              imageUrlController.text.isNotEmpty
                  ? Image.network(
                      imageUrlController.text,
                      height: 500,
                      fit: BoxFit.cover,
                    )
                  : const Text("No image available"),
              const SizedBox(height: 16),
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
