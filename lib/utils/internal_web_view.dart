// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InternalWebView extends StatefulWidget {
  String? url;
  String title;
  bool pdf;
  bool? nfc;

  InternalWebView(
      {super.key, this.url, required this.title, required this.pdf, this.nfc});
  @override
  _InternalWebViewState createState() => _InternalWebViewState();
}

class _InternalWebViewState extends State<InternalWebView> {
  late WebViewController webController;
  final sckey = GlobalKey<ScaffoldState>();
  bool loading = true;
  bool progresoBarra = true;
  int progreso = 0;
  String titulo = "Términos y condiciones";
  late MyAppBar appBar;
  bool pageInit = false;
  //late final CheckInternet _internet;

  @override
  void initState() {
    super.initState();
    /*_internet = Provider.of<CheckInternet>(context, listen: false);
    _internet.checkRealTimeConnection();*/
    //appBar = MyAppBar(sckey: sckey);
    initWebView();
  }

  void initWebView() async {
    if (!widget.pdf) {
      webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(NavigationDelegate(
          onProgress: (int progress) {
            progreso = progress;
          },
          onPageStarted: (String url) {
            if (!pageInit) setState(() => loading = true);
          },
          onPageFinished: (String url) {
            if (!pageInit) setState(() => loading = false);
            if (!pageInit) setState(() => pageInit = true);
            if (!pageInit) setState(() {});
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ))
        ..loadRequest(Uri.parse(
            widget.nfc != null ? "http://${widget.url!}" : widget.url!));

      await webController.getTitle().then((value) {
        setState(() {
          loading = false;
          progresoBarra = false;
        });
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: sckey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            /*connectionWidget(
                status: "ok", //provider.status,
                options: */
            Column(children: [
              //const SizedBox(height: 50),
              if (!widget.pdf) barraProgreso(),
              Expanded(
                  child: !loading
                      ? !widget.pdf
                          ? WebViewWidget(controller: webController)
                          : SfPdfViewer.network(widget.url!)
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                  color: Colors.black),
                              const SizedBox(height: 10),
                              Text("Cargando web... $progreso%",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )),
            ]), //),
            if (progreso == 100)
              Positioned(
                  top: 45,
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 35,
                    ),
                    onPressed: () {
                      sckey.currentState!.openDrawer();
                    },
                  )),
          ],
        )
        //),
        );
    // });
  }

  barraProgreso() {
    return Visibility(
      visible: progresoBarra,
      child: const LinearProgressIndicator(
        minHeight: 5,
        color: Colors.blue,
      ),
    );
  }
}
