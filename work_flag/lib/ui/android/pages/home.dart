import 'package:flutter/material.dart';
import 'package:work_flag/blocs/checkpoint.dart';
import 'package:work_flag/persistence/databases/app_database.dart';
import 'package:work_flag/ui/android/widgets/nav_bar.dart';
import 'package:work_flag/ui/android/widgets/time_button.dart';
import '../../../infrastructure/location.dart';

class HomePage extends StatefulWidget {
  final String title;
  final bool isDarkMode;

  const HomePage({Key key, this.title, this.isDarkMode}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var start = false;
  var stop = true;
  var location = new Location();

  _alterButtonStart() {
    setState(() {
      start = true;
      stop = !start;
    });

    Future.delayed(Duration(seconds: 1)).then(
      (value) => location.getAddressFromLatLgn().then(
        (value) {
          CheckpointBloc checkpoint = new CheckpointBloc(
              date: DateTime.now(), start: DateTime.now(), address: value);

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
        location.isSameLocation(map.address).then((isSame) {
          if (isSame == true) {
            setState(() {
              start = false;
              stop = !start;
            });

            map.stop = DateTime.now();
            updateCheckpoint(map);

            Future.delayed(Duration(seconds: 1)).then((value) => findLast()
                .then((checkpoints) => debugPrint(checkpoints.toString())));
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
        color: Colors.blueGrey,
        child: ListView(
          children: <Widget>[
            widget.isDarkMode
                ? Image.asset("assets/images/home_dark_mode.gif")
                : Image.asset("assets/images/home_light_mode.gif"),
            Button(
              busy: start,
              invert: !start,
              text: "Start",
              func: _alterButtonStart,
            ),
            Button(
              busy: stop,
              invert: !stop,
              text: "Stop",
              func: _alterButtonStop,
            ),
          ],
        ),
      ),
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
