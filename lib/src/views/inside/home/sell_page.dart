// ignore_for_file: deprecated_member_use
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_tv/flutter_swiper.dart';
import 'package:kmello_app/utils/list/data_list_sell.dart';

import '../../../../utils/responsive.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? builderLoadingData()
        : ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: loading ? 5 : listaCategorias.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => setState(() => loading = true),
                child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width > 450
                                ? 300
                                : 200,
                            child: SizedBox(
                              width: double.infinity,
                              height: 250,
                              child: Image.asset(
                                listaCategorias[i].fotoCategoria != ""
                                    ? listaCategorias[i].fotoCategoria!
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
                          SizedBox(
                              height: MediaQuery.of(context).size.width > 450
                                  ? 325
                                  : 200,
                              child: Swiper(
                                viewportFraction: 0.4,
                                scale: 0.85,
                                autoplay: false,
                                autoplayDelay: 3000,
                                pagination: const SwiperPagination(
                                    builder: DotSwiperPaginationBuilder(
                                        space: 5.0,
                                        color: Colors.white,
                                        activeColor: Colors.blue,
                                        size: 8),
                                    margin: EdgeInsets.only(top: 40)),
                                itemCount:
                                    listaCategorias[i].subcategorias!.length,
                                loop: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    450
                                                ? 300
                                                : 20,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            listaCategorias[i]
                                                        .subcategorias![index]
                                                        .fotoCompraSubCategoria !=
                                                    ''
                                                ? listaCategorias[i]
                                                    .subcategorias![index]
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
            });
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
              height: 200,
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
              height: 200,
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
}
