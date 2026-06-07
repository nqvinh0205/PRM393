import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  final List<String> movies = const [
    'The Shawshank Redemption',
    'The Godfather',
    'The Dark Knight',
    'Pulp Fiction',
    'Forrest Gump',
    'Inception',
    'Interstellar',
    'Parasite',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 - Layout Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Top Movies', style: Theme.of(context).textTheme.headlineSmall),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Categories row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chip('All'),
                    const SizedBox(width: 8),
                    _chip('Drama'),
                    const SizedBox(width: 8),
                    _chip('Action'),
                    const SizedBox(width: 8),
                    _chip('Comedy'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Expanded ListView
              Expanded(
                child: ListView.separated(
                  itemCount: movies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final title = movies[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(title),
                        subtitle: const Text('Movie description or year'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label) => Chip(label: Text(label));
}
