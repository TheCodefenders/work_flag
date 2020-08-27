import 'package:flutter/material.dart';

import 'app.dart';
import 'ui/android/material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await start();
  runApp(MyMaterialApp());
}

Future start() async {
  await App.start();
}
