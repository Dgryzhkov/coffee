
import 'dart:convert';
import 'package:flutter/material.dart';

class JsonViewer extends StatelessWidget {
  final String jsonString;

  JsonViewer({required this.jsonString});

  @override
  Widget build(BuildContext context) {
    List<dynamic> jsonData = json.decode(jsonString);

    return ListView.builder(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('delayTime: $delayTime'),
              Text('gradientWeight: $gradientWeight'),
              Text('mixSpeed: $mixSpeed'),
              Text('waterVolume: $waterVolume'),
              Text('canisterId: $canisterId'),
              Text('recipeOutOrder: $recipeOutOrder'),
            ],
          ),
        );
      },
    );
  }
}