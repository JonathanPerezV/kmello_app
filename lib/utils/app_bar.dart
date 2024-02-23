import 'package:flutter/material.dart';

class MyAppBar {
  GlobalKey<ScaffoldState> key;

  MyAppBar({required this.key});

  ThemeData themeData = ThemeData();

  AppBar myAppBar() => AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        backgroundColor: themeData.scaffoldBackgroundColor,
        title: SizedBox(
          width: 130,
          child: Image.asset('assets/kmello_logo.png'),
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
      );

  SliverAppBar mySliverAppBar({required Widget widgethide}) => SliverAppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        backgroundColor: themeData.scaffoldBackgroundColor,
        title: SizedBox(
          width: 130,
          child: Image.asset('assets/kmello_logo.png'),
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
