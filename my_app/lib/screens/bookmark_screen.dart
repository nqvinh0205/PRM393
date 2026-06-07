import 'package:flutter/material.dart';

import '../data/chapter_data.dart';
import '../services/bookmark_service.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() =>
      _BookmarkScreenState();
}

class _BookmarkScreenState
    extends State<BookmarkScreen> {
  List<int> bookmarkIds = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    bookmarkIds =
        await BookmarkService.getBookmarks();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkChapters = chapters
        .where(
          (chapter) =>
              bookmarkIds.contains(chapter.id),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark"),
      ),
      body: ListView.builder(
        itemCount: bookmarkChapters.length,
        itemBuilder: (context, index) {
          final chapter =
              bookmarkChapters[index];

          return ListTile(
            title: Text(chapter.title),
          );
        },
      ),
    );
  }
}