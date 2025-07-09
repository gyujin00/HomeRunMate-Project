import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DbHelper {
  static Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'board.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            views INTEGER DEFAULT 0,
            comments INTEGER DEFAULT 0,
            likes INTEGER DEFAULT 0,
            timestamp TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE chatrooms (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            postId INTEGER,
            name TEXT,
            timestamp TEXT,
            FOREIGN KEY (postId) REFERENCES posts(id)
          )
        ''');
      },
    );
  }

  static Future<int> addPost(Map<String, dynamic> post) async {
    final db = await initDB();
    return db.insert('posts', post);
  }

  static Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await initDB();
    return db.query('posts', orderBy: "timestamp DESC");
  }

  static Future<List<Map<String, dynamic>>> getChatRoomsByPostId(int postId) async {
    final db = await initDB();
    return db.query('chatrooms', where: 'postId = ?', whereArgs: [postId]);
  }

  static Future<int> addMeetup(Map<String, dynamic> meetup) async {
    final db = await initDB();
    return db.insert('meetups', meetup);
  }

  static Future<List<Map<String, dynamic>>> getMeetups() async {
    final db = await initDB();
    return db.query('meetups', orderBy: "timestamp DESC");
  }
}
