import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void flushBarGlobal(BuildContext context, String? mensaje, Icon? icon,
    {Widget? trailing, int? seconds}) {
  Flushbar(
    backgroundColor: Colors.grey.shade900,
    mainButton: trailing,
    duration: Duration(seconds: seconds ?? 2),
    margin: const EdgeInsets.only(bottom: 45, left: 15, right: 15),
    icon: icon,
    message: mensaje,
    messageColor: Colors.white,
    flushbarPosition: FlushbarPosition.BOTTOM,
    borderRadius: BorderRadius.circular(100),
  ).show(context);
}
