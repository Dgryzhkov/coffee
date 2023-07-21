import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/canister.dart';
import '../model/recipe.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static late Database _database;

  String recipesTable = 'recipe';
  String columnId = 'id';
  String canistersTable = 'canisterSet';

  Future<Database> get database async {
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path,
        '/data/data/com.jinuo.mhwang.jetinnocoffe/databases/coffee.db');

      return await openDatabase(path);
  }

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
  Future<int> updateRecipe(Recipe recipe, String newRecipeName) async {
    Database db = await this.database;
    Recipe updatedRecipe = Recipe(
      recipe.id,
      recipe.extra,
      recipe.canisterIds,
      newRecipeName,
      // Update the value here
      recipe.stepses,
      recipe.esAttr,
      recipe.instantAttr,
      recipe.date,
    );
    return await db.update(
      recipesTable,
      updatedRecipe.toMap(),
      where: '$columnId = ?',
      whereArgs: [recipe.id],
    );
  }
}

