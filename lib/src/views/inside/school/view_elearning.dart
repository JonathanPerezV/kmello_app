import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:abi_praxis/src/views/inside/school/aproved.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/list/questions.dart';
import 'package:abi_praxis/utils/responsive.dart';

class Elearning extends StatefulWidget {
  String asset;
  int idCourse;
  Elearning({super.key, required this.asset, required this.idCourse});

  @override
  State<Elearning> createState() => _ElearningState();
}

class _ElearningState extends State<Elearning> {
  late String title;
  late InfiniteScrollController scrollController;

  List<List<Map<String, dynamic>>> listChecks =
      List.generate(listQuestions.length, (index) {
    List<Map<String, dynamic>> result = [];

    List<Map<String, dynamic>> listOptions = [];

    for (var x = 0; x < listQuestions.length; x++) {
      for (var i = 0; i < listQuestions[x]["options"].length; i++) {
        listOptions
            .add(listQuestions[x]["options"][i]..addAll({"group": x + 1}));
      }
    }

    for (var i = 0; i < listOptions.length; i++) {
      result.add({
        "group": listOptions[i]["group"],
        "result": listOptions[i]["result"],
        "data": false
      });
    }

    debugPrint("resultado: ${listOptions.length}");

    return result;
  });

  @override
  void initState() {
    super.initState();
    debugPrint("lista de checks: ${listChecks.length}");
    for (var i = 0; i < listChecks.length; i++) {
      debugPrint("lista de checks: " + listChecks[0][i]["result"].toString());
    }
    scrollController = InfiniteScrollController();
    if (widget.idCourse == 1) {
      title = "CRÉDITOS";
    } else if (widget.idCourse == 2) {
      title = "INTERNET";
    } else if (widget.idCourse == 3) {
      title = "PLANES EXEQUIALES";
    } else if (widget.idCourse == 4) {
      title = "RASTREO SATELITAL";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Image.asset("assets/abi_praxis_logo.png"),
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            color: const Color.fromRGBO(93, 97, 98, 1),
            child: const Text(
              "ESCUELA DE NEGOCIOS / E-LEARNING",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
          header(title, null, path: widget.asset, context: context),
          Expanded(child: questions())
        ],
      );

  Widget questions() => InfiniteCarousel.builder(
      controller: scrollController,
      itemCount: listQuestions.length,
      physics: const NeverScrollableScrollPhysics(),
      itemExtent: MediaQuery.of(context).size.width,
      center: true,
      anchor: 0.0,
      velocityFactor: 0.2,
      onIndexChanged: (index) {},
      axisDirection: Axis.horizontal,
      loop: true,
      itemBuilder: (builder, index, realIndex) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 10),
              width: double.infinity,
              child: Text(
                "${index + 1}- ${listQuestions[index]["question"]}",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
                height: 250, child: Image.asset(listQuestions[index]["asset"])),
            const SizedBox(height: 20),
            Expanded(child: thisOptions(listQuestions[index]["options"])),
            Container(
              margin: const EdgeInsets.only(right: 20),
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerRight,
                child: nextButton(
                    onPressed: () {
                      if (scrollController.selectedItem ==
                          listQuestions.length - 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => Aproved(
                                      asset: widget.asset,
                                      idCourse: widget.idCourse,
                                    )));
                      }
                      setState(() => scrollController.nextItem());
                    },
                    text: "SIGUIENTE",
                    iconSize: 25,
                    width: 250),
              ),
            ),
            const SizedBox(height: 25),
          ],
        );
      });

  Widget thisOptions(List<Map<String, dynamic>> options) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: options.length,
        itemBuilder: (builder, index) {
          return Container(
            margin: const EdgeInsets.only(left: 25, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${options[index]["id"]})",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(options[index]["response"],
                        style: const TextStyle(fontSize: 25)),
                    Expanded(
                        child: Checkbox(
                      value: listChecks[0][index]["data"],
                      onChanged: (value) {
                        setState(() {
                          listChecks[0][index]["data"] = value;
                        });
                      },
                    ))
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
  }
}
