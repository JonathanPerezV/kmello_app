import 'package:flutter/material.dart';

class CustomClipperClass extends StatefulWidget {
  const CustomClipperClass({super.key});

  @override
  State<CustomClipperClass> createState() => _CustomClipperClassState();
}

class _CustomClipperClassState extends State<CustomClipperClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 190,
        child: Stack(children: [
          ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color: Colors.black,
              )),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: const Text(
                "ABI",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  //todo FIGURA MAS ONDULADA (MAIN)
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());

    var path = Path();

    path.lineTo(0, size.height - 60);

    var firstStart = Offset(size.width, size.height - 25);

    var firstEnd = Offset(size.width + 60, size.height - 220.0);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    /*var secondStart =
        Offset(size.width - (size.width / 3.5), size.height - 110);

    var seconEnd = Offset(size.width, size.height - 15);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, seconEnd.dx, seconEnd.dy);

    path.lineTo(size.width, 0);*/

    path.close();

    return path;
  }

  //todo FIGURA NO ONDULADA
  /*Path getClip(Size size) {
    debugPrint(size.width.toString());

    var path = Path();

    path.lineTo(0, size.height - 55);

    var firstStart = Offset(size.width / 6, size.height - 40);

    var firstEnd = Offset(size.width / 3.5, size.height - 50.0);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 4), size.height - 90);

    var seconEnd = Offset(size.width, size.height - 15);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, seconEnd.dx, seconEnd.dy);

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }*/

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    throw UnimplementedError();
  }
}

Widget customHeaderLogin(String logo) => SizedBox(
      height: 190,
      child: Stack(children: [
        ClipPath(
            key: GlobalKey(),
            clipper: WaveClipper(),
            child: Container(
              color: Colors.black,
              height: 190,
            )),
        Center(
          child: Container(
            width: 120,
            margin: const EdgeInsets.only(bottom: 50),
            child: Image.asset(
              logo,
            ),
          ),
        ),
      ]),
    );
