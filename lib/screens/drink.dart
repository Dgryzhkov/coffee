import 'dart:convert';
import 'package:coffee/model/canister.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/db.dart';
import '../model/recipe.dart';

class DrinkPage extends StatefulWidget {
  final Recipe recipe;

  const DrinkPage({super.key, required this.recipe});

  @override
  _DrinkPageState createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {


  late Future<List<Canister>> _canistersList;

  @override
  void initState() {
    super.initState();

    getCanistersList();
  }

  getCanistersList() {
    setState(() {

      _canistersList = DBProvider.db.getCanisters();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> jsonData = json.decode(widget.recipe.stepses ?? '[]');

    ValueNotifier<double> drinkWeight = ValueNotifier<double>(0.0);

// Define and initialize the initialTotalMass variable
    double initialTotalMass = 100.0;

// Calculate the initial drink weight
    double initialDrinkWeight = 0.0;
    for (var data in jsonData) {
      double gradientWeight =
          double.tryParse(data['gradientWeight'] ?? '') ?? 0.0;
      initialDrinkWeight += gradientWeight;
    }

    for (var data in jsonData) {
      double initialWaterMass =
          double.tryParse(data['waterVolume'] ?? '') ?? 0.0;
      initialDrinkWeight += initialWaterMass;
    }

// Create the TextEditingController with the initial drink weight
    TextEditingController drinkWeightController =
        TextEditingController(text: initialDrinkWeight.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.recipe.recipeName}'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: 200,
              height: 200,
              child: Image.asset('assets/image/launch_image.png'),
            ),
            SizedBox(height: 100),
            Text("Вес напитка", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            // TextField widget
            TextField(
              controller: drinkWeightController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Введите вес напитка",
                fillColor: Colors.black12,
                filled: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                double weight = double.tryParse(value) ?? 0.0;
                drinkWeight.value = weight;

                // Calculate the total mass of the drink
                double totalMass = 0.0;
                for (var data in jsonData) {
                  double gradientway = data['gradientWeight'] ?? 0.0;
                  double watevalume = data['waterVolume'] ?? 0.0;
                  totalMass += gradientway + watevalume;
                }

                // Update the values of gradientway and vatevalume based on the entered mass
                for (var data in jsonData) {
                  double gradientway = data['gradientWeight'] ?? 0.0;
                  double vatevalume = data['waterVolume'] ?? 0.0;
                  double gradientwayPercentage = initialTotalMass / gradientway;
                  double watevalumePercentage = initialTotalMass / vatevalume;
                  data['gradientWeight'] = gradientwayPercentage * weight;
                  data['waterVolume'] = watevalumePercentage * weight;
                }
              },
            ),

            const SizedBox(height: 5),
            const Text('Шаги выполнения',style: TextStyle(fontSize: 20)),
            ValueListenableBuilder<double>(
              valueListenable: drinkWeight,
              builder: (context, value, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: jsonData.length,
                  itemBuilder: (context, index) {
                    var data = jsonData[index];
                    String delayTime = data['delayTime'] ?? '';
                    String gradientWeight = data['gradientWeight'] ?? '';
                    String mixSpeed = data['mixSpeed'] ?? '';
                    String waterVolume = data['waterVolume'] ?? '';
                    int canisterId = data['canisterId'] ?? 0;
                    int recipeOutOrder = data['recipeOutOrder'] ?? 0;

                    // Calculate the updated weight of the product and water volume

                    double productWeight = drinkWeight.value *
                        double.parse(gradientWeight) /
                        initialDrinkWeight;

                    double updatedWaterVolume = drinkWeight.value *
                        double.parse(waterVolume) /
                        initialDrinkWeight;

                    if (productWeight == 0) {
                      productWeight = double.parse(gradientWeight);
                    } else {
                      productWeight;
                    }

                    if (updatedWaterVolume == 0) {
                      updatedWaterVolume = double.parse(waterVolume);
                    } else {
                      updatedWaterVolume;
                    }

                    return ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text('Шаг выполнения: ${recipeOutOrder + 1}'),
                          const SizedBox(height: 5),
                          FutureBuilder<List<Canister>>(
                            future: _canistersList,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Canister> canisters = snapshot.data!;
                                Canister selectedCanister =
                                    canisters.firstWhere(
                                  (canister) =>
                                      canister.canisterId == canisterId,
                                );
                                return Text('${selectedCanister.canisterName}');
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                          const SizedBox(height: 5),
                          Text('Время задержки: $delayTime'),
                          const SizedBox(height: 5),
                          Text('Скорость смешивания: $mixSpeed'),
                          const SizedBox(height: 5),
                          Text('Вес ингредиента:$productWeight'),
                          const SizedBox(height: 5),
                          Text('Вес воды: $updatedWaterVolume'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
