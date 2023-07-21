import 'package:flutter/material.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/deviders/divider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _sckey = GlobalKey<ScaffoldState>();

  late TabController tabController;
  late MyAppBar appBar;

  @override
  void initState() {
    super.initState();
    appBar = MyAppBar(key: _sckey);
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar.myAppBar(),
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          Container(
            width: double.infinity,
            height: 35,
            alignment: Alignment.center,
            color: const Color.fromRGBO(93, 97, 98, 1),
            child: const Text(
              "TU SOCIO EN VENTAS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          getTabBar(),
          const SizedBox(height: 5),
          divider(false),
          Expanded(child: getTabBarView())
        ],
      );

  TabBar getTabBar() => TabBar(
          indicator: BoxDecoration(border: Border()),
          labelColor: Colors.black,
          controller: tabController,
          unselectedLabelColor: Colors.grey.shade400,
          tabs: const [
            Tab(
              child: Column(
                children: [Icon(Icons.folder), Text("Consultar")],
              ),
            ),
            Tab(
              child: Column(
                children: [Icon(Icons.sell), Text("Vender")],
              ),
            ),
            Tab(
              child: Column(
                children: [Icon(Icons.folder), Text("Redimir")],
              ),
            )
          ]);

  TabBarView getTabBarView() =>
      TabBarView(controller: tabController, children: [
        Container(
            width: double.infinity, height: double.infinity, color: Colors.red),
        Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.orange),
        Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue),
      ]);
}
