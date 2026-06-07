import 'package:flutter/material.dart';
import 'theme_manager.dart';

class ScaffoldDemo extends StatelessWidget {
  const ScaffoldDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4 - Scaffold & Theme Demo'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, mode, _) {
              return IconButton(
                icon: Icon(mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => themeModeNotifier.value = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                tooltip: 'Toggle theme',
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This screen demonstrates Scaffold structure.', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline),
              label: const Text('Perform action'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('FAB pressed')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
