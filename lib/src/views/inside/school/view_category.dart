import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/inside/school/view_courses.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/list/category.dart';

class ViewCategory extends StatefulWidget {
  const ViewCategory({super.key});

  @override
  State<ViewCategory> createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  List<bool> listBoolCategorys =
      List.generate(categoryList.length, (index) => false);

  @override
  void initState() {
    super.initState();
  }

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
          const SizedBox(height: 40),
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
              "¿En qué categorías deseas capacitarte?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: categoryList.length,
                itemBuilder: (builder, i) {
                  return Column(
                    children: [
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(
                                            Icons.folder_outlined,
                                            size: 30,
                                          ))),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        categoryList[i],
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                                activeColor: Colors.black,
                                checkColor: Colors.white,
                                value: listBoolCategorys[i],
                                onChanged: (value) {
                                  setState(() => listBoolCategorys[i] = value!);
                                })
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      divider(true)
                    ],
                  );
                }),
          ),
          nextButton(
              onPressed: () {
                var data = listBoolCategorys
                    .where((element) => element == true)
                    .toList();

                if (data.isNotEmpty) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => ViewCourses()));
                } else {
                  flushBarGlobal(
                      context,
                      "Seleccione al menos una opción",
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                      ));
                }
              },
              text: "IR A CAPACITARME",
              width: 240,
              fontSize: 20)
        ],
      );
}
