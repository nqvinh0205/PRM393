import 'package:flutter/material.dart';
import 'screens/posts_list_screen.dart';
import 'screens/create_post_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 - Networking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 8 - Networking'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_download,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              const Text(
                'Flutter Networking Demo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Learn how to fetch and manage API data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48),

              // View Posts Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostsListScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('View Posts (GET)'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Create Post Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePostScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.create),
                  label: const Text('Create Post (POST)'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),
              _buildFeatureList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Features Implemented:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 12),
        _FeatureItem('✓ API Service Layer (Separation of Concerns)'),
        _FeatureItem('✓ JSON Model Serialization (Post.fromJson)'),
        _FeatureItem('✓ FutureBuilder for Async UI Binding'),
        _FeatureItem('✓ Loading States with Spinner'),
        _FeatureItem('✓ Error Handling & Retry Button'),
        _FeatureItem('✓ GET Request - Fetch All Posts'),
        _FeatureItem('✓ POST Request - Create New Post'),
        _FeatureItem('✓ Pull-to-Refresh'),
        _FeatureItem('✓ Clean & Professional UI'),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}
