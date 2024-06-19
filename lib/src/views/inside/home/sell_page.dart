// ignore_for_file: deprecated_member_use
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_tv/flutter_swiper.dart';
import 'package:kmello_app/src/models/categorias_model.dart';
import 'package:kmello_app/utils/list/category.dart';
import 'package:kmello_app/utils/list/data_list_sell.dart';
import 'package:kmello_app/utils/textFields/input_text_fields.dart';

import '../../../../utils/responsive.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  bool loading = false;
  List<SubCategoriaModelo> subcategoriasFilter = [];
  List<SubCategoriaModelo> backupSubCat = [];

  final _searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    newDataFiltering();
  }

  void newDataFiltering() {
    for (var i = 0; i < listaCategorias.length; i++) {
      if (listaCategorias[i].subcategorias != null) {
        for (var x = 0; x < listaCategorias[i].subcategorias!.length; x++) {
          subcategoriasFilter.add(listaCategorias[i].subcategorias![x]);
          backupSubCat.add(listaCategorias[i].subcategorias![x]);
          debugPrint("longitud de sub categorias: ${backupSubCat.length}");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? builderLoadingData()
        : Column(
            children: [
              Container(
                color: Colors.grey.shade400,
                child: InputTextFields(
                    controlador: _searchController,
                    inputBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    style: const TextStyle(color: Colors.black),
                    placeHolder: "BUSCAR PRODUCTOS",
                    nombreCampo: null,
                    onChanged: (value) {
                      setState(() => searchText = value);
                      buildSearch();
                    },
                    icon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              buildSearch();
                              setState(() => _searchController.clear());
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            )),
                    accionCampo: TextInputAction.done),
              ),
              Expanded(
                child: _searchController.text.isEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: loading ? 5 : listaCategorias.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            //onTap: () => setState(() => loading = true),
                            child: Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    250
                                                ? 175
                                                : 125,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 250,
                                          child: Image.asset(
                                            listaCategorias[i].fotoCategoria !=
                                                    ""
                                                ? listaCategorias[i]
                                                    .fotoCategoria!
                                                : "assets/no_image_otros.jpeg",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Stack(children: [
                                      listaCategorias[i]
                                                  .subcategorias!
                                                  .length ==
                                              1
                                          ? SizedBox(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      450
                                                  ? 200
                                                  : 150,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  listaCategorias[i]
                                                              .subcategorias![0]
                                                              .fotoCompraSubCategoria !=
                                                          ''
                                                      ? listaCategorias[i]
                                                          .subcategorias![0]
                                                          .fotoCompraSubCategoria!
                                                      : "assets/no_image_otros.jpeg",
                                                  fit: BoxFit.fill,
                                                ),
                                              ))
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      450
                                                  ? 325
                                                  : 200,
                                              child: Swiper(
                                                viewportFraction: 0.35,
                                                scale: 0.85,
                                                autoplay: false,
                                                autoplayDelay: 3000,
                                                pagination: const SwiperPagination(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    builder:
                                                        DotSwiperPaginationBuilder(
                                                            space: 5.0,
                                                            color: Colors.white,
                                                            activeColor:
                                                                Colors.blue,
                                                            size: 8),
                                                    margin: EdgeInsets.only(
                                                        top: 50)),
                                                itemCount: listaCategorias[i]
                                                    .subcategorias!
                                                    .length,
                                                loop: true,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {},
                                                    child: SizedBox(
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                450
                                                            ? 300
                                                            : 20,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.asset(
                                                            listaCategorias[i]
                                                                        .subcategorias![
                                                                            index]
                                                                        .fotoCompraSubCategoria !=
                                                                    ''
                                                                ? listaCategorias[
                                                                        i]
                                                                    .subcategorias![
                                                                        index]
                                                                    .fotoCompraSubCategoria!
                                                                : "assets/no_image_otros.jpeg",
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )),
                                                  );

                                                  //return
                                                },
                                              ))
                                    ]),
                                  ],
                                )),
                          );
                        })
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: subcategoriasFilter.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            // height: 50,
                            child: Stack(
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  subcategoriasFilter[index]
                                              .fotoCompraSubCategoria !=
                                          ''
                                      ? subcategoriasFilter[index]
                                          .fotoCompraSubCategoria!
                                      : "assets/no_image_otros.jpeg",
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 0.67,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                      ),
              ),
              SizedBox(height: 15)
            ],
          );
  }

  Widget builderLoadingData() {
    final rsp = Responsive.of(context);
    return GestureDetector(
      onTap: () => setState(() => loading = false),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CardLoading(
              animationDuration: Duration(milliseconds: 1200),
              borderRadius: BorderRadius.circular(10),
              height: MediaQuery.of(context).size.width > 250 ? 100 : 50,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 200,
              child: GridView(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10),
                children: [
                  CardLoading(
                    margin: EdgeInsets.only(top: 7, bottom: 7),
                    animationDuration: const Duration(milliseconds: 1200),
                    borderRadius: BorderRadius.circular(10),
                    height: 200,
                    width: rsp.wp(32),
                  ),
                  CardLoading(
                    borderRadius: BorderRadius.circular(10),
                    animationDuration: const Duration(milliseconds: 1200),
                    height: 200,
                    width: rsp.wp(32),
                  ),
                  CardLoading(
                    margin: EdgeInsets.only(top: 7, bottom: 7),
                    animationDuration: const Duration(milliseconds: 1200),
                    borderRadius: BorderRadius.circular(10),
                    height: 200,
                    width: rsp.wp(32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            CardLoading(
              animationDuration: Duration(milliseconds: 1200),
              borderRadius: BorderRadius.circular(10),
              height: MediaQuery.of(context).size.width > 250 ? 100 : 50,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 200,
              child: GridView(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10),
                children: [
                  CardLoading(
                    borderRadius: BorderRadius.circular(10),
                    animationDuration: const Duration(milliseconds: 1200),
                    height: 200,
                    width: rsp.wp(32),
                  ),
                  CardLoading(
                    borderRadius: BorderRadius.circular(10),
                    animationDuration: const Duration(milliseconds: 1200),
                    height: 200,
                    width: rsp.wp(32),
                  ),
                  CardLoading(
                    borderRadius: BorderRadius.circular(10),
                    animationDuration: const Duration(milliseconds: 1200),
                    height: 200,
                    width: rsp.wp(32),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<SubCategoriaModelo> buildSearch() {
    if (searchText.isEmpty) {
      return subcategoriasFilter = backupSubCat;
    } else {
      setState(() {
        subcategoriasFilter = backupSubCat
            .where((element) => element.nombreCompraSubCategoria!
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      });
      debugPrint("LONGITUD SEARCH: ${subcategoriasFilter.length}");
      return subcategoriasFilter;
    }
  }
}
