import 'package:flutter/material.dart';

Widget divider(bool? margin, {Color? color}) {
  return Container(
    margin: margin! ? const EdgeInsets.only(left: 15, right: 15) : null,
    color: color ?? Colors.black,
    height: 1,
    //width: double.infinity,
  );
}

Widget dividerMenuLateral() {
  return Container(
    margin: const EdgeInsets.only(left: 15, right: 15),
    color: Colors.grey.shade500,
    height: 1,
    //width: double.infinity,
  );
}
