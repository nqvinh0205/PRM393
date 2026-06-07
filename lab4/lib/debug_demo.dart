import 'package:flutter/material.dart';

class DebugDemo extends StatefulWidget {
  const DebugDemo({super.key});

  @override
  State<DebugDemo> createState() => _DebugDemoState();
}

class _DebugDemoState extends State<DebugDemo> {
  int _itemCount = 5;
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 - Debug & Fix Demo'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fixed layout example', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('This screen uses Expanded with ListView and scroll-safe layout on small screens.'),
                  const SizedBox(height: 8),
                  Text('Selected date: ${_selectedDate?.toLocal().toString().split(' ').first ?? 'None'}'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _itemCount,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text('Fixed item ${index + 1}'),
                      subtitle: const Text('Expanded prevents Column overflow.'),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _itemCount = (_itemCount + 1).clamp(1, 20)),
                      child: const Text('Add item'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Builder(
                      builder: (innerContext) {
                        return ElevatedButton(
                          onPressed: () => _pickDate(innerContext),
                          child: const Text('Pick date'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
