import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common_text_fields.dart';
import '../../widgets/custom_button.dart';

class AddProductScreen extends StatefulWidget {
  final Product? existingProduct;

  const AddProductScreen({super.key, this.existingProduct});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _taxController = TextEditingController();
  final _discountController = TextEditingController();
  String? _selectedCategory;
  File? _selectedImage;

  final List<String> _categories = ['Chain', 'Ring', 'Necklace', 'Bangle', 'Earring', 'Pendant'];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.existingProduct != null) {
      _nameController.text = widget.existingProduct!.name;
      _priceController.text = widget.existingProduct!.price.toString();
      _taxController.text = widget.existingProduct!.tax.toString();
      _discountController.text = widget.existingProduct!.discount.toString();
      _selectedCategory = _categories.contains(widget.existingProduct!.category) ? widget.existingProduct!.category : null;
    }
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final newProduct = Product(
        id: widget.existingProduct?.id ?? '',
        name: _nameController.text,
        price: double.parse(_priceController.text),
        tax: double.tryParse(_taxController.text) ?? 0.0,
        discount: double.tryParse(_discountController.text) ?? 0.0,
        category: _selectedCategory!,
      );

      final provider = Provider.of<ProductProvider>(context, listen: false);
      widget.existingProduct != null ? provider.updateProduct(newProduct) : provider.addProduct(newProduct);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingProduct != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, height: 150)
                    : Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: Icon(Icons.camera_alt, size: 50),
                      ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (val) => val == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 10),
              CommonInputFields.textField(
                controller: _nameController,
                label: 'Name',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 10),
              CommonInputFields.numberField(
                controller: _priceController,
                label: 'Price',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 10),
              CommonInputFields.numberField(
                controller: _taxController,
                label: 'Tax %',
              ),
              SizedBox(height: 10),
              CommonInputFields.numberField(
                controller: _discountController,
                label: 'Discount %',
              ),
              SizedBox(height: 20),
              CustomButton(text: isEditing ? 'Update Product' : 'Save Product', onPressed: _submit)
            ],
          ),
        ),
      ),
    );
  }
}
