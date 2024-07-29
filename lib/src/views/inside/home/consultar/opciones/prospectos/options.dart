import 'package:flutter/material.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/prospectos/clientes/mis_clientes.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/prospectos/prospectos/mis_prospectos.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:timelines/timelines.dart';

import '../../../../../../../utils/app_bar.dart';
import '../../../../../../../utils/icons/kmello_icons_icons.dart';
import '../../../../lateralMenu/drawer_menu.dart';

class OptionsProsp extends StatefulWidget {
  const OptionsProsp({super.key});

  @override
  State<OptionsProsp> createState() => _OptionsProspState();
}

class _OptionsProspState extends State<OptionsProsp>
    with TickerProviderStateMixin {
  final _sckey = GlobalKey<ScaffoldState>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _sckey,
      appBar: MyAppBar(key: _sckey).myAppBar(),
      drawer: drawerMenu(context),
      body: options(),
    );
  }

  Widget options() {
    return Column(
      children: [
        header("Prospectos", KmelloIcons.prospectos, context: context),
        myTabs(),
        Expanded(
          child: myTabBarViews(),
        )
      ],
    );
  }

  Widget myTabs() {
    return TabBar(
        indicator: BoxDecoration(color: Colors.black),
        unselectedLabelColor: Colors.black,
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
        tabs: const [
          Tab(
            child: Text(
              "Mis prospectos",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Tab(
            child: Text(
              "Mis clientes",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ]);
  }

  Widget myTabBarViews() {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [MisProspectos(), MisClientes()]);
  }
}
