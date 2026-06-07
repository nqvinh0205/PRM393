import 'package:flutter/material.dart';
import '../models/book.dart';
import 'chapter_list_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("Tác giả: \\${book.author}"),

            const SizedBox(height: 20),

            Text(book.description),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Xem mục lục"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChapterListScreen(bookId: book.id),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}