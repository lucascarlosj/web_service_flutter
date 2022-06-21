import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Messages {
  Messages._();

  static void alert(String title, String message, BuildContext context) {
    Flushbar(
      title: title,
      message: message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void info(String title, String message, BuildContext context) {
    Flushbar(
      title: title,
      message: message,
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void success(String title, String message, BuildContext context) {
    Flushbar(
      title: title,
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}
