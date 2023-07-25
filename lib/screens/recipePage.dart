import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/db.dart';
import '../model/recipe.dart';
import '../services/ping.dart';
import 'drink.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  var channel = MethodChannel("get_data_bases");

  usbusbusb(){
    channel.invokeMethod("usbusbusb");
  }


  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _recipeNameController = TextEditingController();

  late Future<List<Recipe>> _recipesList;
  late String _recipeName;
  bool isUpdate = false;
  int? recipeIdForUpdate;
  String? extra;
  String? canisterIds;
  String? stepses;
  String? esAttr;
  String? instantAttr;
  String? date;

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
    Timer.periodic(Duration(seconds: 10), (timer) {
      //ping();

      internet().then((result) {
        if (result) {
          print("true");
        } else {
          print("false");
        }
      });


    });



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
                        return 'Please Enter Recipe Name';
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
                      labelText: "Recipe Name ",
                      icon: Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black, fontSize: 50),
                    ),
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: FutureBuilder(
          //     future: _recipesList,
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return generateList(snapshot.data as List<Recipe>);
          //       }
          //       if (snapshot.data == null ||
          //           (snapshot.data as List<Recipe>).isEmpty) {
          //         return Text('No Data Found');
          //       }
          //       return CircularProgressIndicator();
          //     },
          //   ),
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text("Отключить usb"
                    // (isUpdate ? 'UPDATE' : 'ADD'),
                    ),
                onPressed: usbusbusb,
                //     () {
                //   if (isUpdate) {
                //     if (_formStateKey.currentState!.validate()) {
                //       _formStateKey.currentState!.save();
                //       DBProvider.db
                //           .updateRecipe(
                //               Recipe(
                //                   recipeIdForUpdate!,
                //                   extra,
                //                   canisterIds,
                //                   _recipeName,
                //                   stepses,
                //                   esAttr,
                //                   instantAttr,
                //                   date),
                //               _recipeName)
                //           .then((data) {
                //         setState(() {
                //           isUpdate = false;
                //         });
                //       });
                //     } else {}
                //     _recipeNameController.text = '';
                //     getRecipeList();
                //   }
                //   ;
                // },
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text("получить БД"
                    // (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
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
                if (snapshot.data == null ||
                    (snapshot.data as List<Recipe>).length == 0) {
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
                    Text(recipe.recipeName as String,
                        maxLines: 1, style: const TextStyle(fontSize: 45)),
                    onTap: () {
                      recipe.recipeName as String;
                      Route route = MaterialPageRoute(
                          builder: (context) => DrinkPage(recipe: recipe));
                      //Route route = MaterialPageRoute(builder: (context) => CanisterPage());
                      Navigator.push(context, route);
                    },
                    onLongPress: () {
                      setState(() {
                        isUpdate = true;
                        recipeIdForUpdate = recipe.id;
                      });
                      _recipeNameController.text = recipe.recipeName!;
                    },
                  ),
                  DataCell(Image.asset('assets/image/launch_image.png')),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }
}
