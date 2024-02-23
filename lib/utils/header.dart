import 'dart:async';
import 'package:flutter/material.dart';

import 'deviders/divider.dart';

Widget header(String name, IconData? icon,
        {required BuildContext context,
        double? size,
        double? fontSize,
        Timer? timer,
        String? path,
        bool? back,
        Color? color}) =>
    Container(
      color: color ?? Colors.white,
      child: Column(
        children: [
          divider(false),
          Stack(
            children: [
              back == null || !back
                  ? IconButton(
                      onPressed: () async {
                        if (timer != null) timer.cancel();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: color != null ? Colors.white : Colors.black,
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
                        margin: EdgeInsets.only(top: 10),
                        child: Icon(icon,
                            size: size ?? 25,
                            color: color != null ? Colors.white : Colors.black),
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
                      margin: EdgeInsets.only(
                          top: 10,
                          bottom: back != null && back
                              ? 10
                              : path != null
                                  ? 10
                                  : 0),
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: fontSize ?? 22,
                            color: color != null ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          divider(false),
        ],
      ),
    );
