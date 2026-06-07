import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  
  late final ApiService apiService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _userIdController.text = '1';
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final post = await apiService.createPost(
        userId: int.parse(_userIdController.text),
        title: _titleController.text,
        body: _bodyController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post created successfully! ID: ${post.id}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Clear form
        _titleController.clear();
        _bodyController.clear();

        // Show created post details
        _showPostCreatedDialog(post);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPostCreatedDialog(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post Created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${post.id}'),
            const SizedBox(height: 8),
            Text('User: ${post.userId}'),
            const SizedBox(height: 8),
            Text('Title: ${post.title}'),
            const SizedBox(height: 8),
            Text('Body: ${post.body}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // User ID Field
              TextFormField(
                controller: _userIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'User ID is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Must be a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Post Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  if (value.length < 5) {
                    return 'Title must be at least 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Body Field
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Post Body',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Body is required';
                  }
                  if (value.length < 10) {
                    return 'Body must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? 'Creating...' : 'Create Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
