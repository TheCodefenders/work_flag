import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flag/ui/android/pages/checkpoints_list.dart';
import 'package:work_flag/ui/android/pages/home.dart';
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
  _NavDrawerState() {
    load();
  }

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
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: AssetImage("assets/images/options.gif"))),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Histórico de marcação'),
            onTap: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CheckpointList()))
            },
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

  load() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        widget.lights = value.getBool('lightMode') ?? true;
      });
    });
  }
}
