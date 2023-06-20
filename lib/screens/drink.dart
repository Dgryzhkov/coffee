import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/recipe.dart';

class DrinkPage extends StatefulWidget {
  final Recipe recipe;
  DrinkPage({required this.recipe});
  // const DrinkPage({
  //   Key? key,
  // }) : super(key: key);

  @override
  _DrinkPageState createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${this.widget.recipe.recipeName}'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image/launch_image.png'),
            Text('${this.widget.recipe.canisterIds}'),
            Text('${this.widget.recipe.stepses}')
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}
 // Navigator.pop(context);