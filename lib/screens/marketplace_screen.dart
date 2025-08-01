import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/craft_item.dart';
import '../../services/marketplace_service.dart';
import '../../widgets/crafts/craft_item_form.dart';
import '../../widgets/crafts/marketplace_list.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  bool _isLoading = true;
  List<CraftItem> _items = [];

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Schedule the initial load for after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMarketplaceItems();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && mounted) {
      _isInitialized = true;
      // Ensure we're fully initialized before loading data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadMarketplaceItems();
        }
      });
    }
  }

  Future<void> _loadMarketplaceItems() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final marketplaceService = Provider.of<MarketplaceService>(
        context,
        listen: false,
      );
      
      await marketplaceService.loadItems();
      
      if (mounted) {
        setState(() {
          _items = marketplaceService.items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load marketplace items')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMarketplaceItems,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMarketplaceItems,
              child: _items.isEmpty
                  ? const Center(
                      child: Text('No items found'),
                    )
                  : MarketplaceList(items: _items),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCraftItemForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCraftItemForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CraftItemForm(),
    ).then((_) => _loadMarketplaceItems());
  }
}
