import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextFields extends StatelessWidget {
  final String? placeHolder;
  final String? nombreCampo;
  final TextInputAction? accionCampo;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? tipoTeclado;
  final bool? habilitado;
  final void Function(String)? funcion;
  final void Function(String)? onChanged;
  final TextEditingController? controlador;
  final void Function()? onTap;
  final Widget? icon;
  final TextAlign? align;
  final EdgeInsets? padding;
  final int? maxLength;
  final int? maxLines;
  final InputBorder? inputBorder;
  final TextStyle? style;
  final TextCapitalization? mayuscula;
  final Widget? widgetNombreCampo;
  final Widget? suffixIcon;

  const InputTextFields({
    Key? key,
    @required this.placeHolder,
    @required this.nombreCampo,
    @required this.accionCampo,
    this.textInputFormatter,
    this.widgetNombreCampo,
    this.style,
    this.tipoTeclado,
    this.inputBorder,
    this.maxLength,
    this.onChanged,
    this.icon,
    this.habilitado,
    this.controlador,
    this.funcion,
    this.mayuscula,
    this.onTap,
    this.maxLines,
    this.align,
    this.padding,
    this.suffixIcon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        textAlign: align ?? TextAlign.left,
        style: style,
        maxLines: maxLines,
        maxLength: maxLength,
        onTap: onTap,
        onSubmitted: funcion,
        onChanged: onChanged,
        controller: controlador,
        textInputAction: accionCampo,
        inputFormatters: textInputFormatter,
        keyboardType: tipoTeclado,
        textCapitalization: mayuscula ?? TextCapitalization.none,
        enabled: habilitado,
        decoration: InputDecoration(
          contentPadding: padding ?? EdgeInsets.zero,
          border: inputBorder,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          label: widgetNombreCampo,
          hintText: placeHolder,
          labelText: nombreCampo,
        ),
      ),
    );
  }
}
