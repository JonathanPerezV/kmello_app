import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextFormFields extends StatelessWidget {
  final String? valorInicial;
  final TextInputAction? accionCampo;
  final String? placeHolder;
  final String? nombreCampo;
  final TextEditingController? controlador;
  final TextInputType? tipoTeclado;
  final String? Function(String?)? validacion;
  final void Function(String?)? onChanged;
  final List<TextInputFormatter>? listaFormato;
  final Widget? prefixIcon;
  final bool? oscurecerTexto;
  final Widget? icon;
  final InputBorder? inputBorder;
  final TextStyle? estilo, labelStyle;
  final TextCapitalization? capitalization;
  final int? maxLength;
  final int? maxLines;
  final bool? habilitado;
  final TextAlign? align;
  final void Function()? onTap;
  final Widget? widgetNombreCampo;
  final FocusNode? focus;

  const InputTextFormFields(
      {Key? key,
      this.valorInicial,
      @required this.accionCampo,
      @required this.nombreCampo,
      @required this.placeHolder,
      this.labelStyle,
      this.oscurecerTexto,
      this.controlador,
      this.align,
      this.widgetNombreCampo,
      this.maxLines,
      this.capitalization,
      this.inputBorder,
      this.maxLength,
      this.onChanged,
      this.validacion,
      this.estilo,
      this.prefixIcon,
      this.icon,
      this.listaFormato,
      this.tipoTeclado,
      this.habilitado,
      this.onTap,
      this.focus})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        focusNode: focus,
        initialValue: valorInicial,
        textInputAction: accionCampo,
        validator: validacion,
        controller: controlador,
        textAlign: align ?? TextAlign.left,
        maxLength: maxLength,
        onTap: onTap,
        obscureText: oscurecerTexto ?? false,
        onChanged: onChanged,
        inputFormatters: listaFormato,
        enabled: habilitado ?? true,
        style: estilo,
        maxLines: maxLines ?? 1,
        textCapitalization: capitalization ?? TextCapitalization.none,
        keyboardType: tipoTeclado,
        decoration: InputDecoration(
          labelStyle: labelStyle,
          border: inputBorder,
          prefixIcon: prefixIcon,
          suffixIcon: icon,
          hintText: placeHolder,
          labelText: nombreCampo,
          label: widgetNombreCampo,
        ),
      ),
    );
  }
}
