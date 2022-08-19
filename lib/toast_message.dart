import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToast {
  static Future showToast(String msg) async {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 14,
      textColor: Colors.white,
      backgroundColor: Colors.black,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static Future successToast(String msg) async {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 14,
      textColor: Colors.white,
      backgroundColor: Colors.green.shade600,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static Future errorToast(String msg) async {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 14,
      textColor: Colors.white,
      backgroundColor: Colors.red.shade600,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}

