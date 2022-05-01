import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

import '../models/chat.dart';


class SqLiteDbHelper{

  static const _databaseName = "chats_database.db";
  static const _databaseVersion = 1;

  static const table = 'chats';

  static const columnId = 'id';
  static const columnMessage = 'message';
  static const columnSenderId = 'senderId';
  static const columnGroupCode = 'groupCode';
  static const columnTime = 'time';

  SqLiteDbHelper._privateConstructor();
  static final SqLiteDbHelper instance = SqLiteDbHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initializer();
    return _database;
  }

  SqLiteDbHelper();

  Future<Database> initializer() async{
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnMessage TEXT, $columnSenderId TEXT, $columnGroupCode TEXT, $columnTime INTEGER)',
        );
      },
      version: _databaseVersion,
    );

  }

  Future<void> insertChat(Chat chat) async {
    final db = await database;
    await db!.insert(
      table,
      chat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Chat>> chats() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db!.query(table);


    return List.generate(maps.length, (i) {
      return Chat.fromMap(
          maps[i]
      );
    });
  }

  void dbClose() async{
    final db = await database;

    db!.close();
  }

}