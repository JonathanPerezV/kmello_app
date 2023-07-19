import 'dart:async';
import 'package:flutter/material.dart';

import 'deviders/divider.dart';

Widget header(String name, IconData? icon,
        {required BuildContext context,
        double? size,
        double? fontSize,
        Timer? timer,
        String? path,
        bool? notification}) =>
    Column(
      children: [
        divider(false),
        Stack(
          children: [
            notification == null || !notification
                ? IconButton(
                    onPressed: () async {
                      if (timer != null) timer.cancel();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                    ))
                : Container(),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Icon(
                        icon,
                        size: size ?? 25,
                      ),
                    ),
                  if (path != null)
                    Container(
                      width: 40,
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Image.asset(
                        path,
                      ),
                    ),
                  if (icon != null || path != null) const SizedBox(width: 15),
                  Container(
                    margin:
                        EdgeInsets.only(top: 10, bottom: path != null ? 10 : 0),
                    alignment: Alignment.center,
                    child: Text(
                      name,
                      style: TextStyle(fontSize: fontSize ?? 22),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        divider(false),
      ],
    );
