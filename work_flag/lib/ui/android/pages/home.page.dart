import 'package:flutter/material.dart';
import 'package:log_hour/ui/android/widgets/nav.bar.dart';
import 'package:log_hour/ui/android/widgets/time-button.widget.dart';

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
  }

  _alterButtonStop() {
    setState(() {
      start = false;
      stop = !start;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(widget.title ?? 'Teste'),
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
