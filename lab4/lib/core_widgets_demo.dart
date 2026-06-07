import 'package:flutter/material.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'scaffold_demo.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 - Core Widgets Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Lab 4 Demos', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Core Widgets'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Input Controls'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const InputControlsDemo()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_agenda),
              title: const Text('Layout Demo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LayoutDemo()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_iphone),
              title: const Text('Scaffold & Theme Demo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScaffoldDemo()));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Welcome to Flutter UI',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Icon(
                  Icons.movie_creation_outlined,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?auto=format&fit=crop&w=1200&q=80',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: const ListTile(
                  leading: Icon(Icons.star_border),
                  title: Text('Movie Item'),
                  subtitle: Text('This is a sample ListTile inside a Card.'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
