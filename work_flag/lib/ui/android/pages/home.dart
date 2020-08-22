import 'package:flutter/material.dart';
import 'package:work_flag/blocs/checkpoint.dart';
import 'package:work_flag/persistence/databases/app_database.dart';
import 'package:work_flag/ui/android/widgets/nav_bar.dart';
import 'package:work_flag/ui/android/widgets/time_button.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var start = false;
  var stop = true;

  _alterButtonStart() {
    setState(() {
      start = true;
      stop = !start;
    });

    final CheckpointBloc checkpoint = new CheckpointBloc(
      date: DateTime.now(),
      start: DateTime.now(),
    );

    save(checkpoint).then((id) {
      findLast().then((checkpoints) => debugPrint(checkpoints.toString()));
    });
  }

  _alterButtonStop() {
    setState(() {
      start = false;
      stop = !start;
    });

    findLast().then((map) {
      map.stop = DateTime.now();
      updateCheckpoint(map);
    });

    Future.delayed(Duration(seconds: 1)).then((value) => findLast().then((checkpoints) => debugPrint(checkpoints.toString())));
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
}
