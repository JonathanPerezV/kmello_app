// ignore_for_file: deprecated_member_use, must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/utils/app_bar.dart';

class PreVisualizacion extends StatefulWidget {
  String? path;
  CropAspectRatio? radio;
  PreVisualizacion(this.path, {Key? key, this.radio}) : super(key: key);

  @override
  State<PreVisualizacion> createState() => _PreVisualizacionState();
}

class _PreVisualizacionState extends State<PreVisualizacion> {
  final key = GlobalKey<ScaffoldState>();
  late MyAppBar appBar;
  ImageCropper imageCropper = ImageCropper();

  @override
  void initState() {
    super.initState();
    appBar = MyAppBar(key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: appBar.myAppBar(),
      drawer: drawerMenu(context),
      /*persistentFooterButtons: [
              SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Image.asset(
                    value.darkTheme
                        ? 'assets/byBaadal.png'
                        : 'assets/byBaadalColor.png',
                    fit: BoxFit.fitHeight,
                  )),
            ],*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          header(),
          Expanded(
            child: Image.file(
              File(widget.path!),
              fit: BoxFit.contain,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                  child: IconButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () => recortarImagen(),
                      icon: const Icon(
                        Icons.cut,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                  child: IconButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () => Navigator.pop(context, widget.path!),
                      icon: const Icon(
                        Icons.check_sharp,
                        color: Colors.lightGreen,
                        size: 30,
                      )),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cut,
                  color: Colors.white,
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("RECORTAR IMAGEN",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void recortarImagen() async {
    final recortarImagen = await imageCropper.cropImage(
      //cropStyle: CropStyle.rectangle,

      sourcePath: widget.path!,
      compressQuality: 25,
      maxHeight: 200,
      aspectRatio: widget.radio,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar imagen',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.white,
          activeControlsWidgetColor: Colors.grey.shade400,
          hideBottomControls: false,
          dimmedLayerColor: const Color.fromRGBO(10, 10, 10, 120),
          showCropGrid: true,
          cropFrameColor: const Color.fromRGBO(10, 10, 10, 120),
          cropGridColor: Colors.red,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          showCancelConfirmationDialog: true,
          resetAspectRatioEnabled: true,
          hidesNavigationBar: false,
          aspectRatioLockDimensionSwapEnabled: false,
          aspectRatioPickerButtonHidden: false,
          resetButtonHidden: false,
          rotateButtonsHidden: false,
          doneButtonTitle: 'Hecho',
          cancelButtonTitle: 'Cancelar',
          title: 'Recortar imagen',
        ),
      ],
    );
    if (recortarImagen != null) {
      setState(() {
        widget.path = recortarImagen.path;
      });
    }
  }
}
