import 'package:flutter/material.dart';
import 'package:work_flag/ui/android/pages/checkpoints_list.dart';
import 'package:work_flag/ui/android/pages/home.dart';
import 'package:work_flag/ui/android/widgets/preference_theme.dart';
import 'package:work_flag/ui/android/widgets/theme_mode_tile.dart';

class NavDrawer extends StatefulWidget {
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
          BulbLight()
        ],
      ),
    );
  }
}
