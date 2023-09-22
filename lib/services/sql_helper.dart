import 'package:journal_project/models/journal.dart';
import 'package:journal_project/models/journal_dto.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE entries(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      mood TEXT,
      description TEXT,
      timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('journal.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // Create new Journal Entry
  static Future<int> createEntry(JournalDTO journalDTO) async {
    final db = await SQLHelper.db();
    final data = journalDTO.toJson();
    final id = await db.insert('entries', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Read all Journal Entries
  //TODO: return List of Journals instead maybe
  static Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await SQLHelper.db();
    return db.query('entries', orderBy: "timestamp");
  }

  //Read single Journal Entry
  static Future<Journal> getEntry(int id) async {
    final db = await SQLHelper.db();
    final one =
        await db.query('entries', where: "id = ?", whereArgs: [id], limit: 1);
    return Journal.from(one[0]);
  }

  //Update single Journal Entry
  static Future<int> updateEntry(Journal journal) async {
    final db = await SQLHelper.db();
    final data = journal.toJson();
    final id = await db
        .update('entries', data, where: "id = ?", whereArgs: [journal.id]);
    return id;
  }

  //Delete single Journal Entry
  static Future<void> deleteEntry(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('entries', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Could not delete: $err");
    }
  }
}
