import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flag/ui/android/theme/app_themes.dart';
import 'package:work_flag/ui/android/theme/bloc/bloc.dart';
import 'package:work_flag/ui/android/widgets/loading.dart';

class BulbLight extends StatefulWidget {
  bool lights;

  BulbLight({Key key, this.lights}) : super(key: key);

  @override
  _BulbLightState createState() => _BulbLightState();
}

class _BulbLightState extends State<BulbLight> {
  _BulbLightState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        lightBulb(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<bool> getNameImageByPreferences() async {
    return await setPreferences().then((value) {
      var light = value.getBool("lightMode");
      widget.lights = light;
      return light;
    });
  }

  Future<SharedPreferences> setPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Widget lightBulb() {
    return FutureBuilder<bool>(
      future: getNameImageByPreferences(),
      builder: (context, boolLight) {
        switch (boolLight.connectionState) {
          case ConnectionState.none:
            // TODO: Handle this case.
            break;
          case ConnectionState.waiting:
            return Loading();
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            return SwitchListTile(
              title: const Text('Lights'),
              value: widget.lights,
              onChanged: (bool value) {
                setState(() {
                  widget.lights = value;
                });

                BlocProvider.of<ThemeBloc>(context).dispatch(
                  ThemeChanged(
                    theme: widget.lights ? AppTheme.Light : AppTheme.Dark,
                  ),
                );
              },
              secondary: const Icon(Icons.lightbulb_outline),
            );
            break;
        }
        return Center(child: Text("Unknown error"));
      },
    );
  }

  load() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        widget.lights = value.getBool('lightMode') ?? true;
      });
    });
  }
}
