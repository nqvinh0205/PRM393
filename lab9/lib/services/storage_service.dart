import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static const String fileName = 'items.json';

  // Get document directory
  Future<Directory> get documentDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  // Get file path
  Future<File> get file async {
    final dir = await documentDirectory;
    return File('${dir.path}/$fileName');
  }

  // Read JSON file
  Future<List<dynamic>> readItems() async {
    try {
      final file = await this.file;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return jsonDecode(contents);
      }
      return [];
    } catch (e) {
      print('Error reading file: $e');
      return [];
    }
  }

  // Write JSON file
  Future<void> writeItems(List<dynamic> items) async {
    try {
      final file = await this.file;
      await file.writeAsString(jsonEncode(items));
    } catch (e) {
      print('Error writing file: $e');
    }
  }

  // Add item
  Future<void> addItem(Map<String, dynamic> item) async {
    final items = await readItems();
    items.add(item);
    await writeItems(items);
  }

  // Update item
  Future<void> updateItem(int id, Map<String, dynamic> updatedItem) async {
    final items = await readItems();
    final index = items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      items[index] = updatedItem;
      await writeItems(items);
    }
  }

  // Delete item
  Future<void> deleteItem(int id) async {
    final items = await readItems();
    items.removeWhere((item) => item['id'] == id);
    await writeItems(items);
  }

  // Search items
  Future<List<dynamic>> searchItems(String keyword) async {
    final items = await readItems();
    return items
        .where((item) =>
            item['name'].toString().toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}
