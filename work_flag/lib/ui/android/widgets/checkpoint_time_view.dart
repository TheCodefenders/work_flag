import 'package:flutter/material.dart';

class CheckpointTimeView extends StatelessWidget {
  final String time;
  final Color elementColor;
  final double elementWidth;

  CheckpointTimeView(this.time, this.elementColor, this.elementWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width:
        MediaQuery.of(context)
            .size.width * elementWidth,
        child: Card(
          child: Text(time,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: elementColor, //Colors.red,
                height: 3.0,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              )),
        ));
  }
}