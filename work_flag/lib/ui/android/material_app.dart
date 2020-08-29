import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flag/ui/android/pages/home.dart';
import 'package:work_flag/ui/android/theme/bloc/bloc.dart';
import 'package:work_flag/ui/android/theme/bloc/theme_bloc.dart';
import 'package:work_flag/ui/android/widgets/loading.dart';

import 'theme/bloc/theme_bloc.dart';

class MyMaterialApp extends StatefulWidget {
  static SharedPreferences mainSharedPreferences;

  @override
  _MyMaterialAppState createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  var name = 'Marcador Horas';

  Future _loadApp() async {
    MyMaterialApp.mainSharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _builderWithTheme,
      ),
    );
  }

  Widget _builderWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      title: name,
      theme: state.themeData,
      debugShowCheckedModeBanner: false,
      home: LoadingPage(
        title: name,
      ),
      routes: {
        '/home': (context) => HomePage(
              title: name,
            ),
      },
    );
  }
}

class LoadingPage extends StatefulWidget {
  String title;
  LoadingPage({Key key, this.title}) : super(key: key);

  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    loadPage();
  }

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  loadPage() {
    getSharedPrefs().then((prefs) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(
          mainSharedPreferences: prefs,
          title: widget.title,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Loading(LoadingType.Start);
  }
}
