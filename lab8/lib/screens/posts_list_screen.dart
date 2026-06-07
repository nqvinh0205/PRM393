import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  late final ApiService apiService;
  late Future<List<Post>> futurePostsList;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futurePostsList = apiService.fetchPosts();
  }

  /// Retry fetching posts
  void _retryFetch() {
    setState(() {
      futurePostsList = apiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _retryFetch();
          await futurePostsList;
        },
        child: FutureBuilder<List<Post>>(
          future: futurePostsList,
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading posts...'),
                  ],
                ),
              );
            }

            // Error state
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retryFetch,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Data loaded successfully
            if (snapshot.hasData) {
              final posts = snapshot.data!;
              
              if (posts.isEmpty) {
                return const Center(
                  child: Text('No posts available'),
                );
              }

              return ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostListTile(post: post);
                },
              );
            }

            // Shouldn't reach here, but just in case
            return const Center(
              child: Text('No data'),
            );
          },
        ),
      ),
    );
  }
}

/// Custom widget to display a single post
class PostListTile extends StatelessWidget {
  final Post post;

  const PostListTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(
          post.id.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        post.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            post.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'User #${post.userId}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post #${post.id} selected'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
