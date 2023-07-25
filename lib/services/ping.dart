import 'dart:io';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/gestures.dart';

void ping() async {

  final result = await Ping('google.com', count: 1).stream.single;

  print(result);

  //  // Create ping object with desired args
  //  final ping = Ping('ya.ru', count: 1);
  //
  //  // [Optional]
  //  // Preview command that will be run (helpful for debugging)
  // print('Running command: ${ping.command}');
  //
  //  // Begin ping process and listen for output
  //  ping.stream.listen((event) {
  //    print(ping.parser);
  //  });

  // Socket.connect('157.55.39.227', 80, timeout: Duration(seconds: 10))
  //     .then((socket) {
  //   // do what need to be done
  //   print("подключалка работает");
  //   // Don't forget to close socket
  //   socket.destroy();
  // }).catchError((error) {
  //   print(error.toString() + "подключалка не работает");
  // });


}


Future<bool> internet() async {
  var response = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return response=true;
    }
  } on SocketException catch (_) {
    return response;
  }
  return response;
}