import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future errorToast(String errorText) async {
  await Fluttertoast.showToast(
    msg: errorText,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future successToast(String successText) async {
  await Fluttertoast.showToast(
    msg: successText,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
