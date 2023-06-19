
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/recipe.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static late Database _database;

  String recipesTable = 'recipe';
  String columnId = 'id';
  String columnName = 'recipeName';

  Future<Database> get database async {
    //if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "coffee,db");

    final exist = await databaseExists(path);

    if (exist) {
      //db already exists
      // open db
      print("db already exists");
      await openDatabase(path);
    } else {
      //db does not exists create a new one
      print("creating a copy from assets");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "coffee.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      print("db copied");
    }
    await openDatabase(path);
    return await openDatabase(path);
  }
  // READ
  Future<List<Recipe>> getRecipes() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> recipesMapList =
    await db.query(recipesTable);
    final List<Recipe> recipesList = [];
    recipesMapList.forEach((srecipeMap) {
      recipesList.add(Recipe.fromMap(srecipeMap));
    });
    return recipesList;
  }

  // INSERT
  Future<Recipe> insertRecipe(Recipe recipe) async {
    Database db = await this.database;
    recipe.id = await db.insert(recipesTable, recipe.toMap());
    return recipe;
  }

  // UPDATE
  Future<int> updateRecipe(Recipe recipe) async {
    Database db = await this.database;
    return await db.update(
      recipesTable,
      recipe.toMap(),
      where: '$columnId = ?',
      whereArgs: [recipe.id],
    );
  }

  // DELETE
  Future<int> deleteRecipe(int? id) async {
    Database db = await this.database;
    return await db.delete(
      recipesTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
