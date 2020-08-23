import 'package:flutter/material.dart';
import 'pages/home.dart';

class MyMaterialApp extends StatefulWidget {
  final bool isDarkMode;

  const MyMaterialApp({Key key, this.isDarkMode}) : super(key: key);

  @override
  _MyMaterialAppState createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  var name = 'Marcador Horas';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: name,
      debugShowCheckedModeBanner: false,
      theme: widget.isDarkMode
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
      home: HomePage(
        title: name,
        isDarkMode: widget.isDarkMode,
      ),
    );
  }
}
