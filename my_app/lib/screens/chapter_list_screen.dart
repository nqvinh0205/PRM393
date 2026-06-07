import 'package:flutter/material.dart';
import '../data/chapter_data.dart';
import 'reader_screen.dart';

class ChapterListScreen extends StatelessWidget {
  final int bookId;

  const ChapterListScreen({
    super.key,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    final bookChapters = chapters
        .where((chapter) => chapter.bookId == bookId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mục lục"),
      ),
      body: ListView.builder(
        itemCount: bookChapters.length,
        itemBuilder: (context, index) {
          final chapter = bookChapters[index];

          return ListTile(
            title: Text(chapter.title),
            trailing: const Icon(Icons.menu_book),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ReaderScreen(chapter: chapter),
                ),
              );
            },
          );
        },
      ),
    );
  }
}