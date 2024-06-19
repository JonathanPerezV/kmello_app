import 'package:flutter/material.dart';

//todo BOTÓN CONTINAR EN TODOS LOS APARTADOS
Widget nextButton(
        {required Function() onPressed,
        required String text,
        double? width,
        BorderRadiusGeometry? radius,
        double? fontSize,
        double? iconSize,
        Color? background}) =>
    TextButton(
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(2)),
            backgroundColor:
                MaterialStatePropertyAll(background ?? Colors.black),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: radius ?? BorderRadius.circular(100)))),
        onPressed: onPressed,
        child: SizedBox(
          width: width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Colors.white, fontSize: fontSize ?? 18),
                  ),
                ),
              ),
              iconSize != null
                  ? Icon(
                      Icons.arrow_right_alt_outlined,
                      color: Colors.white,
                      size: iconSize,
                    )
                  : Container()
            ],
          ),
        ));
