import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:kmello_app/src/views/inside/school/what_sell/view_courses.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/cut/diagonal_cuts.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/footer.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import 'package:kmello_app/utils/list/category.dart';

import 'products.dart';

class SubCategoryProductList extends StatefulWidget {
  int idCategory;
  String catName;
  SubCategoryProductList(
      {super.key, required this.idCategory, required this.catName});

  @override
  State<SubCategoryProductList> createState() => _SubCategoryProductListState();
}

class _SubCategoryProductListState extends State<SubCategoryProductList> {
  List<Map<String, dynamic>> listSubCategory = [];
  final sckey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchSubCategory();
  }

  void searchSubCategory() {
    final data = subcategorylist
        .where((element) => element["id_category"] == widget.idCategory)
        .toList();

    setState(() => listSubCategory = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: sckey,
      appBar: MyAppBar(key: sckey).myAppBar(),
      drawer: drawerMenu(context),
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          header("Productos", KmelloIcons.productos,
              context: context, back: true),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios)),
                const Icon(
                  Icons.folder_outlined,
                  size: 35,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.catName,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 22),
                  ),
                )
              ],
            ),
          ),
          divider(true),
          Align(
            alignment: Alignment.centerRight,
            child: ClipPath(
              clipper: DiagonalClipper(),
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                width: 245,
                height: 35,
                alignment: Alignment.center,
                color: const Color.fromRGBO(93, 97, 98, 1),
                child: const Text(
                  "Elegir Subcategoría",
                  textAlign: TextAlign.center,
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
                itemCount: listSubCategory.length,
                itemBuilder: (builder, i) {
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => Products(
                                subCatName: listSubCategory[i]["name"],
                                idSubCategory: listSubCategory[i]
                                    ["id_sub_category"]))),
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
                                              child: listSubCategory[i]
                                                  ["icon"])),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            listSubCategory[i]["name"],
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
