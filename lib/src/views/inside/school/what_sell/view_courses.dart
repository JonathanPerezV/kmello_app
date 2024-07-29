import 'dart:io';

import 'package:flutter/material.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/utils/alerts/and_alert.dart';
import 'package:abi_praxis/utils/alerts/ios_alert.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/cut/diagonal_cuts.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/footer.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/list/category.dart';

class ViewSponsors extends StatefulWidget {
  String subCatName;
  int idSubCategory;
  ViewSponsors(
      {super.key, required this.subCatName, required this.idSubCategory});

  @override
  State<ViewSponsors> createState() => _ViewSponsorsState();
}

class _ViewSponsorsState extends State<ViewSponsors> {
  List<Map<String, dynamic>> listSponsors = [];
  final andAlert = AndroidAlert();
  final iosAlert = IosAlert();

  final sckey = GlobalKey<ScaffoldState>();
  late MyAppBar myAppBar;

  @override
  void initState() {
    super.initState();
    myAppBar = MyAppBar(key: sckey);
    searchSubCategory();
  }

  void searchSubCategory() {
    final data = sponsorsList
        .where((element) => element["id_sub_category"] == widget.idSubCategory)
        .toList();

    setState(() => listSponsors = data);
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios)),
                /*const Icon(
                  Icons.folder_outlined,
                  size: 35,
                ),*/
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Text(
                      widget.subCatName,
                      //textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
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
                itemCount: listSponsors.length,
                itemBuilder: (builder, i) {
                  return InkWell(
                    onTap: () => Platform.isAndroid
                        ? andAlert.alertCapcitacion(context)
                        : iosAlert.alertCapcitacion(context),
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
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: listSponsors[i]
                                                        ["color"],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                width: 40,
                                                height: 40,
                                                child: const Center(
                                                    child: Text(
                                                  "S",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                              ))),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            listSponsors[i]["name"],
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
