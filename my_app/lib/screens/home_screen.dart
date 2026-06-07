import 'package:flutter/material.dart';
import 'package:my_app/data/book_data.dart';
import 'book_detail_screen.dart' as book_detail;
import 'package:my_app/screens/bookmark_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện sách'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookmarkScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            elevation: 3,
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.menu_book),
              ),
              title: Text(
                book.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(book.author),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return book_detail.BookDetailScreen(
                        book: book,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}