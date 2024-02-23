import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:kmello_app/src/views/inside/school/what_sell/view_courses.dart';
import 'package:kmello_app/src/views/inside/school/what_sell/view_subcategory.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/cut/diagonal_cuts.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/footer.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/list/category.dart';

class ViewCategory extends StatefulWidget {
  const ViewCategory({super.key});

  @override
  State<ViewCategory> createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  final sckey = GlobalKey<ScaffoldState>();
  late MyAppBar myAppBar;

  @override
  void initState() {
    super.initState();
    myAppBar = MyAppBar(key: sckey);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: sckey,
        appBar: myAppBar.myAppBar(),
        drawer: drawerMenu(context, inicio: false),
        body: options(),
      ),
    );
  }

  Widget options() => Column(
        children: [
          header("¿Qué deseas vender?", null, context: context, back: true),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: ClipPath(
              clipper: DiagonalClipper(),
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                width: 200,
                height: 35,
                alignment: Alignment.center,
                color: const Color.fromRGBO(93, 97, 98, 1),
                child: const Text(
                  "Elegir categoría",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: categoryList.length,
                itemBuilder: (builder, i) {
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ViewSubCategory(
                                catName: categoryList[i]["name"],
                                idCategory: categoryList[i]["id"]))),
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
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
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: categoryList[i]["icon"])),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            categoryList[i]["name"],
                                            style:
                                                const TextStyle(fontSize: 22),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.navigate_next)
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          divider(true)
                        ],
                      ),
                    ),
                  );
                }),
          ),
          footerBaadal(),
          const SizedBox(height: 10),
        ],
      );
}
