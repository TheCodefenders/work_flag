import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flag/ui/android/theme/app_themes.dart';
import 'package:work_flag/ui/android/theme/bloc/bloc.dart';
import 'package:work_flag/ui/android/widgets/preference_theme.dart';

class NavDrawer extends StatefulWidget {
  bool lights;

  NavDrawer({Key key, this.lights}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Text(
                'Opções',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 20,
                ),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor)
//                image: DecorationImage(
//                    fit: BoxFit.fill,
//                    image: AssetImage('assets/images/cover.jpg'))),
              ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Histórico de marcação'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PreferencePage()));
            },
          ),
          SwitchListTile(
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
          )
        ],
      ),
    );
  }

  _NavDrawerState() {
    load();
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getBool('lightMode') ?? true;

    setState(() {
      widget.lights = data;
    });
  }
}
