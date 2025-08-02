import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../models/craft_item.dart';
import '../../../services/marketplace_service.dart';

class CraftItemForm extends StatefulWidget {
  const CraftItemForm({super.key});

  @override
  _CraftItemFormState createState() => _CraftItemFormState();
}

class _CraftItemFormState extends State<CraftItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  final _categoryController = TextEditingController();
  
  String? _imagePath;
  bool _isLoading = false;
  
  final List<String> _categories = [
    'Home & Living',
    'Jewelry',
    'Art',
    'Clothing',
    'Accessories',
    'Toys & Games',
    'Vintage',
    'Craft Supplies',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final item = CraftItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        category: _categoryController.text,
        sellerId: 'current_user_id', // In a real app, get from auth
        sellerName: 'Current User', // In a real app, get from user profile
        // In a real app, you would upload the image to storage and get the URL
        imageUrl: _imagePath,
        rating: 0.0,
        reviewCount: 0,
        isAvailable: true,
      );

      await context.read<MarketplaceService>().addItem(item);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item listed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error listing item: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'List a New Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Product Image
            const Text('Product Image:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          _imagePath!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 40),
                          Text('Add Product Image'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Item Title',
                border: OutlineInputBorder(),
                hintText: 'e.g., Handmade Ceramic Mug',
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Describe your item in detail...',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 16),
            
            // Category
            DropdownButtonFormField<String>(
              value: _categoryController.text.isEmpty ? null : _categoryController.text,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _categoryController.text = value;
                }
              },
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please select a category' : null,
            ),
            const SizedBox(height: 16),
            
            // Price and Stock
            Row(
              children: [
                // Price
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a price';
                      }
                      final price = double.tryParse(value!);
                      if (price == null || price <= 0) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Stock
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Required';
                      }
                      final stock = int.tryParse(value!);
                      if (stock == null || stock < 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('List Item', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
