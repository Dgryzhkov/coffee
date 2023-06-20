import 'package:flutter/material.dart';
import '../db/db.dart';
import '../model/recipe.dart';
import 'drink.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  late Future<List<Recipe>> _recipesList;

  @override
  void initState() {
    super.initState();
    getRecipeList();
  }

  getRecipeList() {
    setState(() {
      _recipesList = DBProvider.db.getRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: _recipesList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data as List<Recipe>);
                }
                if (snapshot.data == null ||
                    (snapshot.data as List<Recipe>).isEmpty) {
                  return Text('No Data Found');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<Recipe> recipes) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('DRINK', style: TextStyle(fontSize: 50)),
            ),
            DataColumn(
              label: Text(' '),
            )
          ],
          rows: recipes
              .map(
                (recipe) => DataRow(cells: [
                  DataCell(
                      Text(recipe.recipeName as String, maxLines: 1,
                          style: const TextStyle(fontSize: 25)), onTap: () {
                    recipe.recipeName as String;
                    Route route = MaterialPageRoute(builder: (context) => DrinkPage(recipe: recipe));
                    //Route route = MaterialPageRoute(builder: (context) => CanisterPage());
                    Navigator.push(context, route);
                  }),
                  DataCell(Image.asset('assets/image/launch_image.png')),
                ]
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
