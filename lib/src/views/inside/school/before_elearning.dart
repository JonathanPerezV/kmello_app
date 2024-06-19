import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/inside/school/view_elearning.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BeforeElearning extends StatefulWidget {
  String asset;
  int idCourse;
  BeforeElearning({super.key, required this.asset, required this.idCourse});

  @override
  State<BeforeElearning> createState() => _BeforeElearningState();
}

class _BeforeElearningState extends State<BeforeElearning>
    with TickerProviderStateMixin {
  late TabController tabController;
  late WebViewController webController;

  late String title;

  bool loadingVideo = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    initializeWebView(null);
    if (widget.idCourse == 1) {
      title = "CRÉDITOS";
    } else if (widget.idCourse == 2) {
      title = "INTERNET";
    } else if (widget.idCourse == 3) {
      title = "PLANES EXEQUIALES";
    } else if (widget.idCourse == 4) {
      title = "RASTREO SATELITAL";
    }
  }

  void initializeWebView(String? url) {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progrees) {
          if (progrees == 100) {
            setState(() => loadingVideo = false);
          }
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          /* if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }*/
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(
          Uri.parse(url ?? "https://www.youtube.com/watch?v=2LEz9CHbBgM"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*persistentFooterButtons: [
        SizedBox(
            height: 50,
            child: Center(
                child: Image.asset("assets/byBaadal.png", fit: BoxFit.cover)))
      ],*/
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 170,
              height: 60,
              child: Image.asset("assets/abi_praxis_logo.png"),
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            color: const Color.fromRGBO(93, 97, 98, 1),
            child: const Text(
              "ESCUELA DE NEGOCIOS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          header(title, null, path: widget.asset, context: context),
          getTabBar(),
          Expanded(child: getTabBarView()),
          const SizedBox(height: 3),
          nextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => Elearning(
                            asset: widget.asset,
                            idCourse: widget.idCourse,
                          ))),
              text: "IR A E-LEARNING",
              width: 200),
          const SizedBox(height: 3),
        ],
      );

  Widget getTabBar() => Stack(
        children: [
          Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.center,
            child: Container(
              width: 1,
              height: 50,
              color: Colors.black,
            ),
          ),
          TabBar(
              physics: NeverScrollableScrollPhysics(),
              onTap: (index) {
                setState(() {
                  webController.clearCache();
                  webController.clearLocalStorage();
                  loadingVideo = true;
                });

                if (index == 0) {
                  initializeWebView(
                      "https://www.youtube.com/watch?v=2LEz9CHbBgM");
                } else {
                  initializeWebView("https://www.orimi.com/pdf-test.pdf");
                }
              },
              indicatorWeight: 1,
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              labelStyle:
                  const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              controller: tabController,
              tabs: [
                const Tab(text: "Video"),
                const Tab(
                  text: "PDF",
                )
              ]),
        ],
      );

  TabBarView getTabBarView() => TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            loadingVideo
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : video(),
            loadingVideo
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : pdf(),
          ]);

  Widget video() => Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            height: 100,
            alignment: Alignment.center,
            color: const Color.fromRGBO(93, 97, 98, 1),
            child: const Text(
              "Observa detenidamente el vídeo, cuando lo hayas comprendido da clic en 'IR A E-LEARNING' para que puedas certificarte por medio de una prueba.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: WebViewWidget(controller: webController))
        ],
      );

  Widget pdf() => Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            height: 100,
            alignment: Alignment.center,
            color: const Color.fromRGBO(93, 97, 98, 1),
            child: const Text(
              "Lee detenidamente la información, cuando lo hayas comprendido da clic en 'IR A E-LEARNING' para que puedas certificarte por medio de una prueba.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: WebViewWidget(controller: webController))
        ],
      );
}
