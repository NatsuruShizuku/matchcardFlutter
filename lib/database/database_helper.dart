
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:flutter_application_0/models/dataModel.dart';

// class DatabaseHelper {
//   static const String _dbName = 'new_word3.db';

//    static Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, _dbName);

//     if (!await databaseExists(path)) {
//       await copyDatabaseFromAssets(path);
//     }

//     final db = await openDatabase(path);

//     // สร้างตาราง HighScores หากไม่มี
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS HighScores (
//         mode TEXT NOT NULL,
//         name TEXT NOT NULL,
//         score INTEGER NOT NULL,
//         timeStamp TEXT NOT NULL
//       )
//     ''');

//     return db;
//   }

//   static Future<void> insertHighScore(HighScore highScore) async {
//     final db = await _initDatabase();
//     await db.insert(
//       'HighScores',
//       highScore.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   static Future<List<HighScore>> getHighScores(String mode) async {
//     final db = await _initDatabase();
//     final List<Map<String, dynamic>> maps = await db.query(
//       'HighScores',
//       where: 'mode = ?',
//       whereArgs: [mode],
//       orderBy: 'score DESC, timeStamp DESC',
//     );
//     return maps.map(HighScore.fromMap).toList();
//   }


//   static Future<void> copyDatabaseFromAssets(String destinationPath) async {
//     try {
//       ByteData data = await rootBundle.load('assets/$_dbName');
//       List<int> bytes = data.buffer.asUint8List();
//       await File(destinationPath).writeAsBytes(bytes, flush: true);
//     } catch (e) {
//       throw Exception("Error copying database from assets: $e");
//     }
//   }

//   /// Fetch all vocabularies with their corresponding matra text
//   static Future<List<Vocabulary>> getVocabularies() async {
//     final db = await _initDatabase();
//     final List<Map<String, dynamic>> maps = await db.rawQuery('''
//       SELECT Vocabulary.*, Matra.matraTEXT 
//       FROM Vocabulary 
//       INNER JOIN Matra ON Vocabulary.matraID = Matra.matraID
//     ''');

//     return maps.map((map) => Vocabulary(
//       vocabID: map['vocabID'],
//       syllable: map['syllable'],
//       vocab: map['vocab'],
//       matraText: map['matraTEXT'],
//       matraID: map['matraID'],
//     )).toList();
//   }

//   /// Fetch all questions from the QuestionM table
//   static Future<List<QuestionM>> getQuestions() async {
//     final db = await _initDatabase();
//     final List<Map<String, dynamic>> maps = await db.query('QuestionM');

//     return maps.map((map) => QuestionM(
//       questionID: map['questionID'],
//       questionText: map['questionTEXT'],
//     )).toList();
//   }

//   /// Fetch all matras from the Matra table
//   static Future<List<Matra>> getMatras() async {
//     final db = await _initDatabase();
//     final List<Map<String, dynamic>> maps = await db.query('Matra');

//     return maps.map((map) => Matra(
//       matraID: map['matraID'],
//       matraText: map['matraTEXT'],
//     )).toList();
//   }

// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "dbbin.db";
  static final _databaseVersion = 1;

  static final table = 't1';
  
  static final columnId = 'id';
  static final columnDescrip = 'descrip';
  static final columnContents = 'contents';
  static final columnMatraID = 'matraID';

  static Database? _database;
  
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    if (!await databaseExists(path)) {
      await copyDatabaseFromAssets(path);
    }
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDescrip TEXT NOT NULL,
        $columnContents BLOB NOT NULL,
        $columnMatraID INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> copyDatabaseFromAssets(String destinationPath) async {
    try {
      ByteData data = await rootBundle.load('assets/$_databaseName');
      List<int> bytes = data.buffer.asUint8List();
      await File(destinationPath).writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw Exception("Error copying database from assets: $e");
    }
  }

  Future<int> insertWord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllWords() async {
    Database db = await instance.database;
    return await db.query(table);
  }
}