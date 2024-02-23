import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingWidget({String? text}) {
  return Container(
    color: const Color.fromRGBO(0, 0, 0, 70),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white, size: 65),
          Text(
            text ?? "Cargando...",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          )
        ],
      ),
    ),
  );
}
