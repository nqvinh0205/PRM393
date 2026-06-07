import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String bookmarkKey = "bookmarks";

  static Future<void> addBookmark(int chapterId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> bookmarks =
        prefs.getStringList(bookmarkKey) ?? [];

    if (!bookmarks.contains(chapterId.toString())) {
      bookmarks.add(chapterId.toString());

      await prefs.setStringList(
        bookmarkKey,
        bookmarks,
      );
    }
  }

  static Future<List<int>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> bookmarks =
        prefs.getStringList(bookmarkKey) ?? [];

    return bookmarks
        .map((e) => int.parse(e))
        .toList();
  }

  static Future<void> removeBookmark(
      int chapterId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> bookmarks =
        prefs.getStringList(bookmarkKey) ?? [];

    bookmarks.remove(chapterId.toString());

    await prefs.setStringList(
      bookmarkKey,
      bookmarks,
    );
  }
}