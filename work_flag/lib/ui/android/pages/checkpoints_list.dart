import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:work_flag/blocs/checkpoint.dart';
import 'package:work_flag/persistence/databases/app_database.dart';
import 'package:work_flag/ui/android/widgets/checkpoint_time_view.dart';
import 'package:work_flag/ui/android/widgets/nav_bar.dart';

class CheckpointList extends StatefulWidget {
  SharedPreferences mainSharedPreferences;

  CheckpointList({Key key, this.mainSharedPreferences}) : super(key: key);

  @override
  _CheckpointListState createState() => _CheckpointListState();
}

class _CheckpointListState extends State<CheckpointList> {
  bool isLightModeMode;

  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  _loadApp() {
    isLightModeMode =
        widget.mainSharedPreferences?.getBool("lightMode") ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        lights: isLightModeMode,
      ),
      appBar: AppBar(
        title: Text("Checkpoints"),
      ),
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)).then((value) => findAll()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Loading..."),
                    )
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              final List<CheckpointBloc> checkpoints = snapshot.data;
              if (checkpoints == null || checkpoints.length == 0) {
                return Center(child: Text("The list has no items!"));
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                    return StickyHeader(
                      header: Container(
                        height: 50.0,
                        color: Colors.blueGrey[700],
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerLeft,
                        child: Text("Data: ${checkpoints[index].date.toString().substring(0, 10)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      content: ListComponent(index, checkpoints),
                    );
                },
                itemCount: checkpoints.length ?? 0,
              );
              break;
          }
          return Center(child: Text("Unknown error"));
        },
      ),
    );
  }

  _CheckpointItem ListComponent(int index, List<CheckpointBloc> checkpoints) {
    index = checkpoints.length - index - 1;
    final CheckpointBloc checkpoint = checkpoints[index];
    return _CheckpointItem(checkpoint);
  }
}

class _CheckpointItem extends StatelessWidget {
  final CheckpointBloc checkpoint;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Column(
        children: [
          Row(
            children: [
              CheckpointTimeView(
                checkpoint.start.toString().substring(11, 19),
                Colors.green,
                0.5,
              ),
              CheckpointTimeView(
                checkpoint.stop != null
                    ? checkpoint.stop.toString().substring(11, 19)
                    : "Not Finished!",
                Colors.red,
                0.5,
              ),
            ],
          ),
          Row(
            children: [
              CheckpointTimeView(
                checkpoint.stop != null
                    ? "Total: ${checkpoint.stop.difference(checkpoint.start).toString().split(".").first}"
                    : "Not Finished!",
                Colors.black,
                1,
              ),
            ],
          ),
          checkpoint.address != null && checkpoint.address != "" ?
          Row(
            children: [
              CheckpointTimeView(
                checkpoint.address,
                Colors.black,
                1,
              ),
            ],
          ) : new Container(width: 0, height: 0)
        ],
      ),
    ]);
  }

  _CheckpointItem(this.checkpoint);
}
