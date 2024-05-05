import 'package:flutter/material.dart';
class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    Key? key,
    required this.textInputAction,
    required this.labelText,
    required this.keyboardType,
    required this.controller,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
    this.maxLength,
    required this.textStyle,
    this.fillColor, // Nueva propiedad para establecer el color de fondo
  }) : super(key: key);

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String labelText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final int? maxLength;
  final TextStyle textStyle; // Propiedad para establecer el estilo de texto
  final Color? fillColor; // Propiedad para establecer el color de fondo

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        maxLength: maxLength,
        onChanged: onChanged,
        autofocus: autofocus ?? false,
        validator: validator,
        obscureText: obscureText ?? false,
        obscuringCharacter: '*',
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: fillColor, // Establecer el color de fondo
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: textStyle, // Usar el estilo de texto proporcionado
      ),
    );
  }
}
