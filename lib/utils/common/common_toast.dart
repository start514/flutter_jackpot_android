import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Common {
  static void showErrorToastMsg(String txt) {
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }
}
