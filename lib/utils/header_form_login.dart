import 'package:flutter/material.dart';

class HeaderFormLogin extends StatelessWidget {
  final Color? colorBorder;
  final Widget? child;
  final String? path;
  final String? fecha;
  final double? width;
  final BorderRadius? borderRadius;
  final double? widthPath;

  const HeaderFormLogin({
    Key? key,
    @required this.width,
    @required this.path,
    @required this.child,
    this.fecha,
    this.borderRadius,
    this.colorBorder,
    this.widthPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Stack(
        children: [
          Container(
              width: width,
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.only(
                  top: 15, left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorBorder ?? Colors.black,
                ),
                borderRadius: borderRadius,
              ),
              child: child),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              alignment: Alignment.center,
              width: widthPath,
              color: Colors.white,
              height: 5,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              //color: Color.fromRGBO(255, 255, 255, 50),
              width: widthPath,
              alignment: Alignment.center,
              height: 35,
              child: Image.asset(
                path!,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
