import 'package:flutter/material.dart';

class MyAppBar {
  GlobalKey<ScaffoldState> key;

  MyAppBar({required this.key});

  ThemeData themeData = ThemeData();

  AppBar myAppBar({bool? back, BuildContext? context}) => AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        backgroundColor: Colors.white, //themeData.scaffoldBackgroundColor,
        title: SizedBox(
          width: 90,
          child: Image.asset('assets/abi_praxis_logo.png'),
        ),
        centerTitle: true,
        leading: back != null && back
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context!),
              )
            : IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () => key.currentState!.openDrawer(),
              ),
      );

  SliverAppBar mySliverAppBar({required Widget widgethide}) => SliverAppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        backgroundColor: Colors.white, //themeData.scaffoldBackgroundColor,
        title: SizedBox(
          width: 90,
          child: Image.asset('assets/abi_praxis_logo.png'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => key.currentState!.openDrawer(),
        ),
        floating: true,
        pinned: true,
        snap: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(93),
          child: widgethide,
        ),
      );
}
