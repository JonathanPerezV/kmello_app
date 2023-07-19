import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/inside/school/before_elearning.dart';
import 'package:kmello_app/utils/list/category.dart';

import '../../../../utils/buttons.dart';
import '../../../../utils/deviders/divider.dart';
import '../../../../utils/header.dart';

class ViewCourses extends StatefulWidget {
  const ViewCourses({super.key});

  @override
  State<ViewCourses> createState() => _ViewCoursesState();
}

class _ViewCoursesState extends State<ViewCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
            height: 50,
            child: Center(
                child: Image.asset("assets/byBaadal.png", fit: BoxFit.cover)))
      ],
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 170,
              height: 60,
              child: Image.asset("assets/kmello_logo.png"),
            ),
          ),
          const SizedBox(height: 10),
          header("ESCUELA DE NEGOCIOS", null, context: context),
          Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            color: const Color.fromRGBO(93, 97, 98, 1),
            child: const Text(
              "LISTADO DE CURSOS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: coursesList.length,
                itemBuilder: (builder, i) {
                  return Column(
                    children: [
                      const SizedBox(height: 25),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                coursesList[i]["asset"]),
                                          ))),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        coursesList[i]["title"],
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => BeforeElearning(
                                          asset: coursesList[i]["asset"],
                                          idCourse: coursesList[i]["id"]))),
                              child: Container(
                                height: 45,
                                width: 90,
                                child: const Stack(children: [
                                  Text(
                                    "Ir al curso",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child:
                                          Icon(Icons.arrow_right_alt_rounded))
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      divider(true)
                    ],
                  );
                }),
          ),
          nextButton(
              onPressed: () {},
              text: "VER OTRAS CATEGORÍAS",
              width: 290,
              fontSize: 20)
        ],
      );
}
