import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MyToast {
  BuildContext context;
  String msg1;
  String msg2;
  Duration duration;
  Color color;
  FlushbarPosition position;
  bool loading;

  MyToast.name();

  MyToast(this.context, this.msg1, this.msg2, this.duration, this.color,
      this.position, this.loading);

  showToast() async {
    Flushbar(
      title: msg1,
      message: msg2,
      duration: duration,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color,
      showProgressIndicator: loading,
      progressIndicatorBackgroundColor: Colors.white,
      margin: EdgeInsets.all(12.0),
      borderRadius: 8,
    )..show(context);
  }
}
