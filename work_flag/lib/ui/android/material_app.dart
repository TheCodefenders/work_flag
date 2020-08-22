import 'package:flutter/material.dart';
import 'pages/home.dart';

class MyMaterialApp extends StatelessWidget {
  var name = 'Marcador Horas';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(
        title: name,
      ),
    );
  }
}
