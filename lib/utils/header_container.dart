// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class HeaderContainer extends StatelessWidget {
  /// variable de tipo width_container, especifíca el ancho del contenedor
  double? width_container;

  /// variable de tipo width_container, especifíca la altura del contenedor
  double? height_container;

  ///El margen del contenedor será 0.0, en caso de que requiera que el contenedor no esté pegado al borde del dispositivo, asignar margen
  ///margin_container: EdgeInsets.only(left: 15, right: 15);
  EdgeInsets? margin_container;

  ///Si el complemento tiene título primero deberá habilitar esta opción
  ///de lo contario no aparecerá el texto widget ingresado como title
  ///
  ///declara false si tu ilustración no necesita título
  ///```dart
  ///has_title: false
  ///```
  ///declara true si tu ilustración si necesita título
  ///```dart
  ///has_title: true
  ///```
  bool has_title;

  ///Widget para poner el título en la línea superior del contenedor.
  ///title: Row(children:[Text("Hola mundo"), Icon(Icons.abc)])
  Widget? title;

  ///Widget que estará en el cuerpo del contenedor
  ///```dart
  ///body: Text("Hola mundo");
  ///```
  Widget body;

  ///En caso de tener un header, un titular dentro del contenedor, puedes seleccionar un color
  ///en caso de no necesitar color, no enviar nada
  ///ej: color: Colors.white
  Color? color_header;

  bool has_header;

  Widget? header;
  BorderRadius? radius;

  HeaderContainer(
      {super.key,
      required this.body,
      required this.has_header,
      required this.has_title,
      this.margin_container,
      this.height_container,
      this.radius,
      this.title,
      this.width_container,
      this.color_header,
      this.header});

  @override
  Widget build(BuildContext context) {
    double padding_top = 0.0;

    if (has_title) {
      padding_top = 20;
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: padding_top),
          child: Container(
            margin: margin_container,
            padding: has_title ? const EdgeInsets.only(top: 10) : null,
            width: width_container ?? double.infinity,
            height: height_container ?? 100.0,
            decoration: BoxDecoration(
                borderRadius: radius ?? BorderRadius.circular(0.0),
                border: Border.all()),
            child: Column(
              mainAxisAlignment: has_header
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                if (has_header)
                  Container(
                    decoration: BoxDecoration(
                        color: color_header,
                        borderRadius: radius != null
                            ? BorderRadius.only(
                                topLeft: radius!.topLeft,
                                topRight: radius!.topRight)
                            : null),
                    width: double.infinity,
                    height: 50,
                    child: Center(child: header),
                  ),
                if (has_title) Center(child: body),
                if (has_header)
                  Expanded(
                    child: body,
                  )
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: title != null ? title! : Container())
      ],
    );
  }
}
