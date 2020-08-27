import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flag/ui/android/theme/app_themes.dart';
import '../../../../app.dart';
import './bloc.dart';
import '../app_themes.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  AppTheme getTheme() {
    return App.blocInnitPreference.getBool("lightMode")
        ? AppTheme.Light
        : AppTheme.Dark;
  }

  @override
  ThemeState get initialState =>
      ThemeState(themeData: appThemeData[getTheme()]);

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      save(event.theme.toString() == AppTheme.Light.toString());
      yield ThemeState(themeData: appThemeData[event.theme]);
    }
  }

  save(bool value) async {
    getInstance().then((prefs) => prefs.setBool("lightMode", value));
  }

  Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }
}
