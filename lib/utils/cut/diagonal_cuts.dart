import 'package:flutter/material.dart';

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(20, 0); // Línea superior izquierda
    path.lineTo(size.width, 0); // Línea diagonal hacia abajo
    path.lineTo(size.width, size.height); // Línea inferior derecha
    path.lineTo(0, size.height); // Línea inferior izquierda
    path.close(); // Cierra el contorno
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
