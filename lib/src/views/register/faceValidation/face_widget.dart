// ignore_for_file: use_build_context_synchronously, unused_local_variable, must_be_immutable
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:abi_praxis/src/models/user_moderl.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';
import 'package:progress_border/progress_border.dart';

/// CameraApp is the Main Application.
class FaceWidget extends StatefulWidget {
  UserModel usuario;
  String? advice;

  /// Default Constructor
  FaceWidget({Key? key, required this.advice, required this.usuario})
      : super(key: key);

  @override
  State<FaceWidget> createState() => _FaceWidgetState();
}

class _FaceWidgetState extends State<FaceWidget>
    with SingleTickerProviderStateMixin {
  late CameraController controller;

  late List<CameraDescription> _cameras;

  late AnimationController animationController;

  bool takePicture = false;

  bool loadingCamera = true;

  Future<void> getCameras() async {
    final data = await availableCameras();

    setState(() => _cameras = data);
    controller =
        CameraController(_cameras[1], ResolutionPreset.max, enableAudio: false);

    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller.setZoomLevel(1.5);

      initializeAnimationController();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  void initializeAnimationController() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    animationController.addListener(() async {
      setState(() {});
      debugPrint(animationController.value.toString());
      if (animationController.value == 1) {
        setState(() => takePicture = true);

        final picture = await controller.takePicture();

        setState(() => takePicture = false);

        final image.Image originalImage =
            image.decodeImage(await picture.readAsBytes())!;

        image.Image orientedImage = image.flipHorizontal(originalImage);

        List<int> imageBytesOrientation = image.encodeJpg(orientedImage);

        final data =
            await File(picture.path).writeAsBytes(imageBytesOrientation);

        if (widget.advice != null) {
          Navigator.pop(context);
        }
        Navigator.pop(context, data.path);

        debugPrint(picture.path);
      }
    });

    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      setState(() => loadingCamera = false);
      start();
    });
  }

  void start() {
    if (animationController.status == AnimationStatus.forward ||
        // reverse if forward is completed and if we click
        animationController.value >= 1) {
      // on start button
      animationController.reverse();
    } else {
      // forward animation while starting
      animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    getCameras(); //.then((value) => initializeAnimationController());
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingCamera
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : options(),
    );
  }

  Widget options() => Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 170,
              height: 60,
              child: Image.asset("assets/abi_praxis_logo.png"),
            ),
          ),
          const SizedBox(height: 10),
          divider(true),
          Row(
            children: [
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios)),
              const Row(children: [
                Icon(KmelloIcons.validar_identidad),
                SizedBox(width: 5),
                Text(
                  "Tomar foto",
                  style: TextStyle(fontSize: 23.5),
                )
              ])
            ],
          ),
          divider(true),
          const SizedBox(height: 20),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1 / controller.value.aspectRatio,
              child: Stack(
                children: [
                  controller.buildPreview(),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      //margin: const EdgeInsets.only(bottom: 80),
                      alignment: Alignment.center,
                      width: 350,
                      height: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 7,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      //margin: const EdgeInsets.only(bottom: 80),
                      alignment: Alignment.center,
                      width: 350,
                      height: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                        border: ProgressBorder.all(
                          color: Colors.greenAccent,
                          width: 8,
                          progress: animationController.value,
                        ),
                      ),
                    ),
                  ),
                  if (takePicture)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: const Color.fromRGBO(255, 255, 255, 60),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
}
