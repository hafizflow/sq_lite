import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = 'Notes.db';

  /// -- Generate Database
  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute(
          "CREATE TABLE Note(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL);"),
      version: _version,
    );
  }

  /// -- add note
  static Future<int> addNote(Note note) async {
    final db = await _getDB();
    return await db.insert(
      'Note',
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// -- update note
  static Future<int> updateNote(Note note) async {
    final db = await _getDB();
    return await db.update(
      'Note',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// -- delete note
  static Future<int> deleteNote(Note note) async {
    final db = await _getDB();
    return await db.delete(
      'Note',
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// -- get note
  static Future<List<Note>?> getAllNote() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> notes = await db.query('Note');

    if (notes.isEmpty) return null;

    return List.generate(notes.length, (index) => Note.fromJson(notes[index]));
  }
}
