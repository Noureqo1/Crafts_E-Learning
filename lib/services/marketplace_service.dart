import 'package:flutter/foundation.dart';
import '../models/craft_item.dart';

class MarketplaceService extends ChangeNotifier {
  List<CraftItem> _items = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CraftItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load marketplace items from Firestore (mock implementation for now)
  Future<void> loadItems({String? category}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would be a Firestore query
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Mock data
      _items = [
        // Carpentry Tools
        CraftItem(
          id: '1',
          title: 'Professional Wood Chisel Set',
          description: 'High-quality 6-piece wood chisel set with leather roll. Perfect for fine woodworking and detailed carpentry projects.',
          price: 89.99,
          sellerId: 'woodcraft_tools',
          sellerName: 'WoodCraft Tools',
          category: 'Carpentry Tools',
          stock: 15,
          rating: 4.9,
          reviewCount: 87,
          isAvailable: true,
        ),
        CraftItem(
          id: '2',
          title: 'Japanese Pull Saw',
          description: 'Premium Japanese-style pull saw with dual cutting edges. Excellent for precision woodworking and fine joinery.',
          price: 45.50,
          sellerId: 'eastern_woodworks',
          sellerName: 'Eastern Woodworks',
          category: 'Carpentry Tools',
          stock: 8,
          rating: 4.8,
          reviewCount: 64,
          isAvailable: true,
        ),
        
        // Wood Materials
        CraftItem(
          id: '3',
          title: 'Premium Walnut Wood Plank',
          description: 'Kiln-dried American black walnut, 1" x 8" x 48". Perfect for furniture making and decorative projects.',
          price: 75.00,
          sellerId: 'fine_lumber_co',
          sellerName: 'Fine Lumber Co.',
          category: 'Wood Materials',
          stock: 5,
          rating: 4.7,
          reviewCount: 32,
          isAvailable: true,
        ),
        
        // Handmade Furniture
        CraftItem(
          id: '4',
          title: 'Handcrafted Oak Dining Table',
          description: 'Solid oak dining table, handcrafted with traditional joinery. Seats 6-8 people. Custom sizes available.',
          price: 1200.00,
          sellerId: 'artisan_furniture',
          sellerName: 'Artisan Furniture Co.',
          category: 'Furniture',
          stock: 2,
          rating: 5.0,
          reviewCount: 18,
          isAvailable: true,
        ),
        
        // Woodworking Plans
        CraftItem(
          id: '5',
          title: 'Complete Woodworking Plans Collection',
          description: 'Digital download of 50+ professional woodworking plans including furniture, decor, and shop projects.',
          price: 29.99,
          sellerId: 'diy_plans',
          sellerName: 'DIY Wood Plans',
          category: 'Plans & Guides',
          stock: 1000, // Digital item
          rating: 4.9,
          reviewCount: 143,
          isAvailable: true,
        ),
        
        // Workshop Equipment
        CraftItem(
          id: '6',
          title: 'Professional Workbench with Vise',
          description: 'Heavy-duty workbench with front vise and tool well. Perfect for all your woodworking needs.',
          price: 450.00,
          sellerId: 'woodcraft_tools',
          sellerName: 'WoodCraft Tools',
          category: 'Workshop Equipment',
          stock: 3,
          rating: 4.8,
          reviewCount: 27,
          isAvailable: true,
        ),
        
        // Finishing Supplies
        CraftItem(
          id: '7',
          title: 'Natural Wood Finish Kit',
          description: 'All-natural wood finish kit including oil, wax, and applicators. Safe for food contact surfaces.',
          price: 34.99,
          sellerId: 'natural_wood_co',
          sellerName: 'Natural Wood Co.',
          category: 'Finishing Supplies',
          stock: 12,
          rating: 4.6,
          reviewCount: 42,
          isAvailable: true,
        ),
        
        // Hand Tools
        CraftItem(
          id: '8',
          title: 'Premium Dovetail Saw',
          description: 'Handcrafted dovetail saw with Japanese steel blade and walnut handle. Perfect for fine joinery work.',
          price: 125.00,
          sellerId: 'eastern_woodworks',
          sellerName: 'Eastern Woodworks',
          category: 'Carpentry Tools',
          stock: 5,
          rating: 4.9,
          reviewCount: 38,
          isAvailable: true,
        ),
      ];

      // Filter by category if provided
      if (category != null) {
        _items = _items.where((item) => item.category == category).toList();
      }
    } catch (e) {
      _error = 'Failed to load items: $e';
      debugPrint('Error loading marketplace items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new item to the marketplace
  Future<void> addItem(CraftItem item) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would save to Firestore
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      _items = [item, ..._items];
    } catch (e) {
      _error = 'Failed to add item: $e';
      debugPrint('Error adding marketplace item: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing item
  Future<void> updateItem(CraftItem updatedItem) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would update in Firestore
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _items.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        _items[index] = updatedItem;
      }
    } catch (e) {
      _error = 'Failed to update item: $e';
      debugPrint('Error updating marketplace item: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete an item
  Future<void> deleteItem(String itemId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would delete from Firestore
      await Future.delayed(const Duration(milliseconds: 500));
      
      _items.removeWhere((item) => item.id == itemId);
    } catch (e) {
      _error = 'Failed to delete item: $e';
      debugPrint('Error deleting marketplace item: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get items by seller
  List<CraftItem> getItemsBySeller(String sellerId) {
    return _items.where((item) => item.sellerId == sellerId).toList();
  }

  // Get items by category
  List<CraftItem> getItemsByCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  // Search items
  List<CraftItem> searchItems(String query) {
    if (query.isEmpty) return [];
    final lowercaseQuery = query.toLowerCase();
    return _items.where((item) {
      return item.title.toLowerCase().contains(lowercaseQuery) ||
          item.description.toLowerCase().contains(lowercaseQuery) ||
          item.sellerName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get all available categories
  List<String> getCategories() {
    final categories = _items.map((item) => item.category).toSet().toList();
    categories.sort();
    return categories;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Purchase an item (reduce stock)
  Future<bool> purchaseItem(String itemId, int quantity) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // In a real app, this would update stock in Firestore
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final item = _items[index];
        if (item.stock >= quantity) {
          _items[index] = item.copyWith(stock: item.stock - quantity);
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      _error = 'Failed to process purchase: $e';
      debugPrint('Error processing purchase: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
