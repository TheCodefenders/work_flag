import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flag/blocs/checkpoint.dart';
import 'package:work_flag/persistence/databases/app_database.dart';
import 'package:work_flag/ui/android/widgets/home_image.dart';
import 'package:work_flag/ui/android/widgets/location_footer.dart';
import 'package:work_flag/ui/android/widgets/nav_bar.dart';
import 'package:work_flag/ui/android/widgets/time_button.dart';
import '../../../infrastructure/location.dart';

class HomePage extends StatefulWidget {
  final String title;
  SharedPreferences mainSharedPreferences;
  bool isStarted = false;
  String address = "";
  Location location;

  HomePage({
    Key key,
    this.title,
    this.mainSharedPreferences,
    this.address,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLightModeMode;
  var start = false;
  var stop = true;

  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  _loadApp() {
    isLightModeMode =
        widget.mainSharedPreferences?.getBool("lightMode") ?? true;

    widget.location = new Location();
    widget.location.getAddressFromLatLgn();

    findLast().then((map) {
      Future.delayed(Duration(milliseconds: 500)).then((dl) {
        if (map.stop == null) {
          setState(() {
            start = true;
            stop = !start;
            widget.isStarted = true;
          });
        }
      });
    });
  }

  _alterButtonStart() {
    setState(() {
      start = true;
      stop = !start;
      widget.isStarted = true;
    });

    Future.delayed(Duration(seconds: 1)).then(
      (value) => widget.location.getAddressFromLatLgn().then(
        (value) {
          CheckpointBloc checkpoint = new CheckpointBloc(
              date: DateTime.now(), start: DateTime.now(), address: value);

          setState(() {
            widget.address = value ?? "";
          });

          save(checkpoint).then((id) {
            findLast()
                .then((checkpoints) => debugPrint(checkpoints.toString()));
          });
        },
      ),
    );
  }

  _alterButtonStop() {
    findLast().then((map) {
      Future.delayed(Duration(seconds: 1)).then((dl) {
        widget.location.isSameLocation(map.address).then((isSame) {
          if (isSame == true) {
            setState(() {
              start = false;
              stop = !start;
              widget.isStarted = false;
            });

            map.stop = DateTime.now();
            updateCheckpoint(map);

            Future.delayed(Duration(seconds: 1)).then((value) => findLast()
                .then((checkpoints) => debugPrint(checkpoints.toString())));

            setState(() {
              widget.address = "";
            });
          } else {
            _showMyDialog();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(widget.title ?? "Test"),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: AnimatedContainer(
        duration: Duration(
          milliseconds: 1200,
        ),
        color: start ? Colors.black87 : Colors.black45,
        child: ListView(
          children: <Widget>[
            HomeImages(),
            !widget.isStarted
                ? Button(
                    busy: start,
                    invert: !start,
                    text: "Start",
                    func: _alterButtonStart,
                  )
                : Button(
                    busy: stop,
                    invert: !stop,
                    text: "Stop",
                    func: _alterButtonStop,
                  ),
          ],
        ),
      ),
      persistentFooterButtons: [
        LocationFooter(),
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro ao salvar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'A localização de encerramento deve ser a mesma do inicio'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
