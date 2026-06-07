import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetch all posts from the API
  /// Returns a list of Post objects
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/posts'),
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        // Convert to List<Post>
        final List<Post> posts = jsonList
            .map((json) => Post.fromJson(json as Map<String, dynamic>))
            .toList();
        
        return posts;
      } else {
        throw Exception('Failed to load posts. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  /// Fetch a single post by ID
  Future<Post> fetchPostById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/posts/$id'),
      );

      if (response.statusCode == 200) {
        final Post post = Post.fromJson(jsonDecode(response.body));
        return post;
      } else {
        throw Exception('Failed to load post. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching post: $e');
    }
  }

  /// Create a new post via POST request
  /// Returns the created Post object
  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 201) {
        final Post post = Post.fromJson(jsonDecode(response.body));
        return post;
      } else {
        throw Exception('Failed to create post. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  /// Delete a post by ID
  Future<bool> deletePost(int id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/posts/$id'),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }
}
