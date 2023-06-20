
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/canister.dart';
import '../model/recipe.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static late Database _database;

  String recipesTable = 'recipe';

  String canistersTable  = 'canisterSet';


  Future<Database> get database async {
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
  // READ DB
  Future<List<Recipe>> getRecipes() async {
    Database db = await database;
    final List<Map<String, dynamic>> recipesMapList =
    await db.query(recipesTable);
    final List<Recipe> recipesList = [];
    recipesMapList.forEach((recipeMap) {
      recipesList.add(Recipe.fromMap(recipeMap));
    });
    return recipesList;
  }

  Future<List<Canister>> getCanisters() async {
    Database db = await database;
    final List<Map<String, dynamic>> canistersMapList =
    await db.query(canistersTable);
    final List<Canister> canistersList = [];
    canistersMapList.forEach((canisterMap) {
      canistersList.add(Canister.fromMap(canisterMap));
    });
    return canistersList;
  }

  // UPDATE
  // Future<int> updateRecipe(Recipe recipe) async {
  //   Database db = await this.database;
  //   return await db.update(
  //     recipesTable,
  //     recipe.toMap(),
  //     where: '$columnId = ?',
  //     whereArgs: [recipe.id],
  //   );
  // }


}
