import 'package:flutter/material.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/src/views/inside/school/what_sell/view_courses.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/cut/diagonal_cuts.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/footer.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/list/category.dart';

class ViewSubCategory extends StatefulWidget {
  String catName;
  int idCategory;
  ViewSubCategory({super.key, required this.catName, required this.idCategory});

  @override
  State<ViewSubCategory> createState() => _ViewSubCategoryState();
}

class _ViewSubCategoryState extends State<ViewSubCategory> {
  List<Map<String, dynamic>> listSubCategory = [];

  final sckey = GlobalKey<ScaffoldState>();
  late MyAppBar myAppBar;

  @override
  void initState() {
    super.initState();
    myAppBar = MyAppBar(key: sckey);
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                            builder: (builder) => ViewSponsors(
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
