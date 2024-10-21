import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agenda.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contatos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'usuarios',
      {
        'username': username,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isUserExist(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await database;
    return await db.query('contatos');
  }

  Future<void> insertContact(Map<String, dynamic> contact) async {
    final db = await database;
    await db.insert(
      'contatos',
      contact,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateContact(int id, Map<String, dynamic> contact) async {
    final db = await database;
    await db.update(
      'contatos',
      contact,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await database;
    await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
