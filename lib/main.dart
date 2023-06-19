

import 'package:coffee/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'db/db.dart';
import 'model/recipe.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite CRUD Demo',
      home: SplashScreen(),
    );
  }
}

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _recipeNameController = TextEditingController();

  late Future<List<Recipe>> _recipesList;
  late String _recipeName;
  bool isUpdate = false;
  int? recipeIdForUpdate;

  @override
  void initState() {
    super.initState();
    updateRecipeList();
  }

  updateRecipeList() {
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
          Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please Enter Coffee Name';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    },
                    onSaved: (value) {
                      _recipeName = value!;
                    },
                    controller: _recipeNameController,
                    decoration: InputDecoration(
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.greenAccent,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      labelText: "Coffee Name",
                      icon: Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text(
                  (isUpdate ? 'UPDATE' : 'ADD'),
                ),
                onPressed: () {
                  if (isUpdate) {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db
                          .updateRecipe(
                          Recipe(recipeIdForUpdate!, _recipeName,null,null,null,null,null,null))
                          .then((data) {
                        setState(() {
                          isUpdate = false;
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      // DBProvider.db.insertStudent(Student(null, _studentName));
                      DBProvider.db.insertRecipe(Recipe(null, _recipeName,null,null,null,null,null,null));
                    }
                  }
                  _recipeNameController.text = '';
                  updateRecipeList();
                },
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text(
                  (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
                ),
                onPressed: () {
                  _recipeNameController.text = '';
                  setState(() {
                    isUpdate = false;
                    recipeIdForUpdate = null; // null;
                  });
                },
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: _recipesList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data as List<Recipe>);
                }
                if (snapshot.data == null || (snapshot.data as List<Recipe>).length == 0) {
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
          columns: [
            DataColumn(
              label: Text('NAME'),
            ),
            DataColumn(
              label: Text('DELETE'),
            ),
          ],
          rows: recipes
              .map(
                (recipe) => DataRow(cells: [
              DataCell(Text(recipe.recipeName as String), onTap: () {
                setState(() {
                  isUpdate = true;
                  recipeIdForUpdate = recipe.id;
                });
                _recipeNameController.text = recipe.recipeName as String;
              }),
              DataCell(
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DBProvider.db.deleteRecipe(recipe.id);
                    updateRecipeList();
                  },
                ),
              ),
            ]),
          )
              .toList(),
        ),
      ),
    );
  }
}