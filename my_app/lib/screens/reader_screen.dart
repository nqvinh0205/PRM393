import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../services/bookmark_service.dart';

class ReaderScreen extends StatefulWidget {
  final Chapter chapter;

  const ReaderScreen({
    super.key,
    required this.chapter,
  });

  @override
  State<ReaderScreen> createState() =>
      _ReaderScreenState();
}

class _ReaderScreenState
    extends State<ReaderScreen> {
  Future<void> saveBookmark() async {
    await BookmarkService.addBookmark(
      widget.chapter.id,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã thêm bookmark"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: saveBookmark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            widget.chapter.content,
            style: const TextStyle(
              fontSize: 18,
              height: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}