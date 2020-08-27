import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_flag/blocs/checkpoint.dart';
import 'package:work_flag/persistence/databases/app_database.dart';
import 'package:work_flag/ui/android/widgets/nav_bar.dart';

class CheckpointList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
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
                  index = checkpoints.length - index - 1;
                  final CheckpointBloc checkpoint = checkpoints[index];
                  return _CheckpointItem(checkpoint);
                },
                itemCount: checkpoints?.length ?? 0,
              );
              break;
          }
          return Center(child: Text("Unknown error"));
        },
      ),
    );
  }
}

class _CheckpointItem extends StatelessWidget {
  final CheckpointBloc checkpoint;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(top:18.0),
              child: ListTile(
                title: Text(checkpoint.date.toString().substring(0, 10),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.2,
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text(checkpoint?.address ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          )),
      Column(
        children: [
          Row(
            children: [
              Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Card(
                    child:
                        Text("${checkpoint.start.toString().substring(11, 19)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              height: 3.0,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            )),
                  )),
              Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Card(
                    child: Text(
                        checkpoint.stop != null
                            ? checkpoint.stop.toString().substring(11, 19)
                            : "Not Finished!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          height: 3.0,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        )),
                  )),
            ],
          ),
          Row(
            children: [
              Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Card(
                    child: Text(
                        checkpoint.stop != null
                            ? "Total: ${checkpoint.stop
                                  .difference(checkpoint.start)
                                  .toString().split(".").first
                                }"
                            : "Not Finished!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          height: 3.0,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        )),
                  )),
            ],
          )
        ],
      ),
    ]);
  }

  _CheckpointItem(this.checkpoint);
}
