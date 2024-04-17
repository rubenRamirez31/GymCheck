import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static final navigationKey = GlobalKey<NavigatorState>();

  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+",
  );

 // Expresión regular para aceptar cualquier dato
  static final RegExp passwordRegex = RegExp(
    r'^.{8,}$', // Acepta cualquier carácter y debe tener al menos 8 caracteres de longitud
  );
  static final RegExp nickRegex = RegExp(
    r'^[a-zA-Z0-9]{3,16}$'
  );
}
