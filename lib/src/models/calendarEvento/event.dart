import 'package:flutter/material.dart';

class Event {
  int? id;
  String? title;
  String? descripcion;
  DateTime? from;
  DateTime? to;
  Color? backgroundColor;
  bool? isAllDay;

  Event(
      {@required this.title,
      @required this.descripcion,
      @required this.from,
      @required this.to,
      @required this.id,
      this.backgroundColor = Colors.lightGreen,
      this.isAllDay = false});
}
