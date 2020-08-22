import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  var text = "";
  Function func;
  var invert = false;
  var busy = false;

  Button({
    @required this.busy,
    @required this.invert,
    @required this.func,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: invert
              ? Theme.of(context).primaryColor
              : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(
            60,
          )),
      child: FlatButton(
        child: Text(
          this.text,
          style: TextStyle(
            color: invert
                ? Colors.white.withOpacity(0.8)
                : Theme.of(context).primaryColor,
            fontSize: 25,
            fontFamily: "Big Shoulders Display",
          ),
        ),
        onPressed: func,
      ),
    );
  }
}
