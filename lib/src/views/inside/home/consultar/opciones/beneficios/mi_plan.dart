import 'package:flutter/material.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/footer.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';

class MiPlan extends StatefulWidget {
  const MiPlan({super.key});

  @override
  State<MiPlan> createState() => _MiPlanState();
}

class _MiPlanState extends State<MiPlan> {
  final sckey = GlobalKey<ScaffoldState>(); 

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
          header("Mi Plan", KmelloIcons.plan, context: context),
          Expanded(child: SingleChildScrollView(child: plan())),
          footerBaadal()
        ],
      );

  Widget plan() => Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: const Text(
              "Username, tu plan está activo",
              style: TextStyle(fontSize: 19),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => {},
            child: Container(
              padding: const EdgeInsets.only(left: 5),
              height: 40,
              width: 195,
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  const Center(
                      child: Text(
                    "Llama para acceder",
                  )),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4)),
                        height: 40,
                        width: 30,
                        child: const Icon(
                          Icons.call,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 210,
            child: Image.asset(
              "assets/plan/Ambulancia.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Ambulancia 100%",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          divider(true, color: Colors.grey),
          const SizedBox(height: 20),
          SizedBox(
            width: 210,
            child: Image.asset(
              "assets/plan/Telefonica.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Consulta médica \n Telefónica 100%",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
        ],
      );
}
