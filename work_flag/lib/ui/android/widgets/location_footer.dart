import 'package:flutter/material.dart';
import 'package:work_flag/blocs/checkpoint.dart';
import 'package:work_flag/persistence/databases/app_database.dart';
import 'package:work_flag/ui/android/widgets/loading.dart';

class LocationFooter extends StatefulWidget {
  @override
  _LocationFooterState createState() => _LocationFooterState();
}

class _LocationFooterState extends State<LocationFooter> {
  @override
  Widget build(BuildContext context) {
    return location();
  }

  Widget location() {
    return FutureBuilder<CheckpointBloc>(
        future: findLast(),
        builder: (context, checkpoint) {
          switch (checkpoint.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              return Loading(LoadingType.Home);
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              return Container(
                width: 900,
                child: (checkpoint.data.start.toString() != "" &&
                        (checkpoint.data.stop.toString() == "" ||
                            checkpoint.data?.stop == null))
                    ? Text(
                        checkpoint.data.address,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      )
                    : Text(""),
              );
              break;
          }
          return Center(child: Text("Unknown error"));
        });
  }
}
