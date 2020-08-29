import 'package:flutter/material.dart';

enum LoadingType { Light, Start, Home, Checkpoint }

final loading = {
  LoadingType.Light: "assets/images/light_load.gif",
  LoadingType.Home: "assets/images/options.gif",
  LoadingType.Start: "assets/images/start_load.gif",
  LoadingType.Checkpoint: "assets/images/checkpoint_load.gif",
};

class Loading extends StatelessWidget {
  LoadingType mode;
  double width;

  Loading(this.mode, {this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      loading[this.mode],
      width: this.width ?? 80,
    );
  }
}
