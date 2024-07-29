import 'package:flutter/material.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';

Widget footerBaadal() => Column(
      children: [
        divider(true),
        Container(
          color: Colors.white,
          width: double.infinity,
          height: 60,
          child: Image.asset("assets/byBaadal.png"),
        ),
        //const SizedBox(height: 10)
      ],
    );
