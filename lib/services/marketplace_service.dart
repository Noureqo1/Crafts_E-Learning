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
        CraftItem(
          id: '1',
          title: 'Handmade Ceramic Mug',
          description: 'Beautiful handcrafted ceramic mug, perfect for your morning coffee.',
          price: 24.99,
          sellerId: 'seller1',
          sellerName: 'Artisan Crafts',
          category: 'Home & Living',
          stock: 10,
          rating: 4.8,
          reviewCount: 124,
          isAvailable: true,
        ),
        CraftItem(
          id: '2',
          title: 'Crochet Blanket',
          description: 'Soft and cozy crochet blanket, made with love and care.',
          price: 89.99,
          sellerId: 'seller2',
          sellerName: 'Cozy Creations',
          category: 'Home & Living',
          stock: 3,
          rating: 4.9,
          reviewCount: 87,
          isAvailable: true,
        ),
        CraftItem(
          id: '3',
          title: 'Wooden Phone Stand',
          description: 'Elegant wooden phone stand, perfect for your desk or nightstand.',
          price: 19.99,
          sellerId: 'seller3',
          sellerName: 'Wooden Wonders',
          category: 'Electronics',
          stock: 15,
          rating: 4.6,
          reviewCount: 56,
          isAvailable: true,
        ),
        // Add more mock items as needed
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
