import 'dart:convert';
import 'package:coffee/model/canister.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.recipe.recipeName}'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:
        SingleChildScrollView(
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
            Text("Вес напитка"),
            TextField(decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Введите вес напитка",
                fillColor: Colors.black12,
                filled: true,
            ),
              keyboardType: TextInputType.number,
            ),
            Text('Шаги выполнения'),
            ListView.builder(
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

                return ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text('Время задержки: $delayTime'),
                      SizedBox(height: 5),
                      Text('Вес продукта: $gradientWeight'),
                      SizedBox(height: 5),
                      Text('Скорость смешивания: $mixSpeed'),
                      SizedBox(height: 5),
                      Text('Объем воды: $waterVolume'),
                      SizedBox(height: 5),
                      Text('ID компонента: $canisterId'),
                      SizedBox(height: 5),
                      Text('Шаг выполнения: ${recipeOutOrder+1}'),
                      SizedBox(height: 5),
                    ],
                  ),

                );
              },
            ),

          ],
        ),
      ),
    );
  }
}

//   SingleChildScrollView generateList(List<Canister> canisters) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: DataTable(
//           columns: const [
//             DataColumn(
//               label: Text('Состав', style: TextStyle(fontSize: 50)),
//             ),
//             // DataColumn(
//             //   label: Text(' '),
//             // )
//           ],
//           rows: canisters
//               .map(
//                 (canister) => DataRow(cells: [
//                   DataCell(Text(canister.canisterName as String,
//                       style: const TextStyle(fontSize: 20))),
//                   //DataCell(Image.asset('assets/image/launch_image.png')),
//                 ]),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }
// }

// Navigator.pop(context);

// Expanded(
//   child: FutureBuilder(
//     future: _canistersList,
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return generateList(snapshot.data as List<Canister>);
//       }
//       if (snapshot.data == null ||
//           (snapshot.data as List<Canister>).isEmpty) {
//         return Text('No Data Found');
//       }
//       return CircularProgressIndicator();
//     },
//   ),
// ),
