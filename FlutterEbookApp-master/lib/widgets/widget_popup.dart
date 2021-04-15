import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Widget snackBar3Sec(BuildContext context, String aviso) {
  return Flushbar(
    leftBarIndicatorColor: Colors.white,
    backgroundColor: Color(0xFF012F3D),
    flushbarPosition: FlushbarPosition.BOTTOM,
    message: aviso,
    duration: Duration(seconds: 3),
  )..show(context);
}
