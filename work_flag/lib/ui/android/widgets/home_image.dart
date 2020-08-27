import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeImages extends StatefulWidget {
  final images = {
    true: "assets/images/home_light_mode.gif",
    false: "assets/images/home_dark_mode.gif"
  };

  @override
  _HomeImagesState createState() => _HomeImagesState();
}

class _HomeImagesState extends State<HomeImages> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        image(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<Image> getImageByPreferences() async {
    return await getNameImageByPreferences()
        .then((value) => Image.asset(value));
  }

  Future<String> getNameImageByPreferences() async {
    return await setPreferences()
        .then((value) => widget.images[value.getBool("lightMode")]);
  }

  Future<SharedPreferences> setPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<Image> imgFt;

  Widget image() {
    return FutureBuilder<Image>(
      future: getImageByPreferences(),
      builder: (context, snapshot) => snapshot.data,
    );
  }
}