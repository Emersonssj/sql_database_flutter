import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/autor_model.dart';
import '../models/group_by.dart';
import '../models/livro_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'livraria.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE autores(
          id INTEGER PRIMARY KEY,
          autorName TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE livros(
          id INTEGER PRIMARY KEY,
          livroName TEXT,
          autorName TEXT,
          exemplares INTEGER
      )
      ''');
  }

  Future<List<Autor>> getAutores() async {
    Database db = await instance.database;
    var autores = await db.rawQuery('SELECT * FROM autores ORDER BY autorName');
    print(autores);
    List<Autor> autorList =
        autores.isNotEmpty ? autores.map((c) => Autor.fromMap(c)).toList() : [];
    return autorList;
  }

  Future<int> addAutores(Autor autor) async {
    Database db = await instance.database;
    return await db.rawInsert(
        'INSERT INTO autores (id, autorName) VALUES (null, "${autor.autorName}")');
  }

  Future<int> removeAutores(int id) async {
    Database db = await instance.database;
    //return await db.delete('autores', where: 'id = ?', whereArgs: [id]);
    return await db.rawDelete('DELETE FROM autores WHERE id=$id');
  }

  Future<int> updateAutores(Autor autor) async {
    Database db = await instance.database;
    //return await db.update('autores', autor.toMap(),
    //    where: "id = ?", whereArgs: [autor.id]);
    return await db.rawUpdate(
        'UPDATE autores SET autorName="${autor.autorName}" WHERE id=${autor.id}');
  }

//

  Future<List<Livro>> getLivros() async {
    Database db = await instance.database;
    var livros = await db.rawQuery('SELECT * FROM livros ORDER BY livroName');
    print(livros);
    List<Livro> livroList =
        livros.isNotEmpty ? livros.map((c) => Livro.fromMap(c)).toList() : [];
    return livroList;
  }

  Future<int> addLivros(Livro livro) async {
    Database db = await instance.database;
    //return await db.insert('livros', livro.toMap());
    return await db.rawInsert(
        'INSERT INTO livros (id, livroName, autorName, exemplares) VALUES (null, "${livro.livroName}", "${livro.autorName}", "${livro.exemplares}")');
  }

  Future<int> removeLivros(int id) async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM livros WHERE id=$id');
    //return await db.delete('livros', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateLivros(Livro livro) async {
    Database db = await instance.database;
    //return await db.update('livros', livro.toMap(),
    //    where: "id = ?", whereArgs: [livro.id]);
    return await db.rawUpdate(
        'UPDATE livros SET livroName="${livro.livroName}", autorName="${livro.autorName}", exemplares="${livro.exemplares}"  WHERE id=${livro.id}');
  }

  //

  Future<List<GroupBy>> getLivrosPorAutor() async {
    Database db = await instance.database;
    //var autores = await db.query('autores', orderBy: 'autorName');
    var groupByQuery = await db.rawQuery(
        'SELECT autorName, SUM(exemplares) AS totalLivros FROM livros GROUP BY autorName ORDER BY autorName ASC');
    print(groupByQuery);
    List<GroupBy> groupByList = groupByQuery.isNotEmpty
        ? groupByQuery.map((c) => GroupBy.fromMap(c)).toList()
        : [];
    return groupByList;
  }

  //

  Future<List<GroupBy>> getSubQuery() async {
    Database db = await instance.database;
    //var autores = await db.query('autores', orderBy: 'autorName');
    var groupByQuery = await db.rawQuery(
        'SELECT autorName, totalLivros FROM (SELECT autorName, SUM(exemplares) AS totalLivros FROM livros GROUP BY autorName ORDER BY autorName ASC) WHERE totalLivros>50');
    print(groupByQuery);
    List<GroupBy> groupByList = groupByQuery.isNotEmpty
        ? groupByQuery.map((c) => GroupBy.fromMap(c)).toList()
        : [];
    return groupByList;
  }
}
