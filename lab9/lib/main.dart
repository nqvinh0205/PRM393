import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - JSON Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lab 9 - JSON Management'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Lab 9.1\nRead Assets'),
            Tab(text: 'Lab 9.2\nStorage'),
            Tab(text: 'Lab 9.3\nCRUD DB'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Lab91Screen(),
          Lab92Screen(),
          Lab93Screen(),
        ],
      ),
    );
  }
}

// Lab 9.1 - Read JSON From Assets
class Lab91Screen extends StatefulWidget {
  const Lab91Screen({super.key});

  @override
  State<Lab91Screen> createState() => _Lab91ScreenState();
}

class _Lab91ScreenState extends State<Lab91Screen> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJsonFromAssets();
  }

  Future<void> _loadJsonFromAssets() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/items.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      setState(() {
        items = jsonData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading JSON: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : items.isEmpty
            ? const Center(child: Text('No items found'))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${item['id']}'),
                      ),
                      title: Text(item['name'] ?? 'Unknown'),
                      subtitle: Text(
                        'Price: \$${item['price']}, Qty: ${item['quantity']}',
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  );
                },
              );
  }
}

// Lab 9.2 - Save & Load JSON From Device Storage
class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  final StorageService _storage = StorageService();
  List<dynamic> items = [];
  bool isLoading = true;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final loadedItems = await _storage.readItems();
    setState(() {
      items = loadedItems;
      isLoading = false;
    });
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newItem = {
      'id': items.isEmpty ? 1 : (items.last['id'] as int) + 1,
      'name': _nameController.text,
      'price': double.parse(_priceController.text),
      'quantity': int.parse(_quantityController.text),
    };

    await _storage.addItem(newItem);
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();

    await _loadItems();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added successfully!')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Add New Item',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addItem,
                      child: const Text('Add Item'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isLoading
                ? const CircularProgressIndicator()
                : items.isEmpty
                    ? const Text('No items saved yet')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${item['id']}'),
                              ),
                              title: Text(item['name'] ?? 'Unknown'),
                              subtitle: Text(
                                'Price: \$${item['price']}, Qty: ${item['quantity']}',
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// Lab 9.3 - JSON CRUD Mini Database
class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  final StorageService _storage = StorageService();
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  bool isLoading = true;

  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  Future<void> _loadItems() async {
    final loadedItems = await _storage.readItems();
    setState(() {
      items = loadedItems;
      filteredItems = loadedItems;
      isLoading = false;
    });
  }

  void _filterItems() {
    final query = _searchController.text;
    setState(() {
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items
            .where((item) =>
                item['name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newItem = {
      'id': items.isEmpty ? 1 : (items.last['id'] as int) + 1,
      'name': _nameController.text,
      'price': double.parse(_priceController.text),
      'quantity': int.parse(_quantityController.text),
    };

    await _storage.addItem(newItem);
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();

    await _loadItems();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added successfully!')),
    );
  }

  Future<void> _editItem(dynamic item) async {
    _nameController.text = item['name'];
    _priceController.text = item['price'].toString();
    _quantityController.text = item['quantity'].toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final updatedItem = {
                'id': item['id'],
                'name': _nameController.text,
                'price': double.parse(_priceController.text),
                'quantity': int.parse(_quantityController.text),
              };
              await _storage.updateItem(item['id'], updatedItem);
              await _loadItems();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _storage.deleteItem(id);
              await _loadItems();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item deleted successfully!')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _addItem,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                    ? const Center(child: Text('No items found'))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${item['id']}'),
                              ),
                              title: Text(item['name'] ?? 'Unknown'),
                              subtitle: Text(
                                'Price: \$${item['price']}, Qty: ${item['quantity']}',
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () => _editItem(item),
                                    child: const Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    onTap: () => _deleteItem(item['id']),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
