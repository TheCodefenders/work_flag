import 'package:shared_preferences/shared_preferences.dart';

class App {
  static SharedPreferences blocInnitPreference;

  static Future start() async {
    blocInnitPreference = await SharedPreferences.getInstance();
  }
}
