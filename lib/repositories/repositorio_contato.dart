import 'package:sqflite/sqflite.dart';
import '../models/contato.dart';
import '../db/database_helper.dart';

class ContatoRepository {
  final dbHelper = DatabaseHelper();

  Future<List<Contato>> getContatos() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('contatos');

    return List.generate(maps.length, (i) {
      return Contato(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        telefone: maps[i]['telefone'],
        email: maps[i]['email'],
      );
    });
  }

  Future<void> adicionarContato(Contato contato) async {
    final db = await dbHelper.database;
    await db.insert(
      'contatos',
      contato.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> atualizarContato(Contato contato) async {
    final db = await dbHelper.database;
    await db.update(
      'contatos',
      contato.toMap(),
      where: 'id = ?',
      whereArgs: [contato.id],
    );
  }

  Future<void> removerContato(int id) async {
    final db = await dbHelper.database;
    await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
