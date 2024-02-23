import 'package:flutter/material.dart';
import 'package:kmello_app/utils/deviders/divider.dart';

Widget footerBaadal() => Column(
      children: [
        divider(true),
        Container(
          width: double.infinity,
          height: 70,
          child: Image.asset("assets/byBaadal.png"),
        ),
        const SizedBox(height: 10)
      ],
    );
