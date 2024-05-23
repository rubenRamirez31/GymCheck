import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/alimento.dart';

import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';

class FoodService {
  static Future<void> agregarAlimento(
      BuildContext context, Food food) async {
    try {
      final foodCollectionRef =
          FirebaseFirestore.instance.collection('Alimentos');

      final foodMap = food.toMap();

      await foodCollectionRef.add(foodMap);

      print('Alimento agregado con éxito.');
    } catch (error) {
      print('Error al agregar el alimento: $error');
      throw error;
    }
  }

  static Future<void> agregarAFavoritos(
      BuildContext context, Food food) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      final nick = globales.nick;

      final userFavoritesDocRef =
          FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);

      final userFoodCollectionRef =
          userFavoritesDocRef.collection('Alimentos');

      final existingFood =
          await userFoodCollectionRef.doc(food.id).get();
      if (existingFood.exists) {
        print('Este alimento ya está en favoritos.');
        return;
      }

      await userFoodCollectionRef.doc(food.id).set({
        'id': food.id,
        'name': food.name,
        // Agrega aquí cualquier otro dato que desees guardar
      });

      print('Alimento agregado a favoritos con éxito.');
    } catch (error) {
      print('Error al agregar el alimento a favoritos: $error');
      throw error;
    }
  }

  static Future<void> quitarDeFavoritos(
      BuildContext context, String foodId) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      final nick = globales.nick;

      final userFavoritesDocRef =
          FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);

      final userFoodCollectionRef =
          userFavoritesDocRef.collection('Alimentos');

      final existingFood =
          await userFoodCollectionRef.doc(foodId).get();
      if (!existingFood.exists) {
        print('Este alimento no está en favoritos.');
        return;
      }

      await userFoodCollectionRef.doc(foodId).delete();

      print('Alimento eliminado de favoritos con éxito.');
    } catch (error) {
      print('Error al quitar el alimento de favoritos: $error');
      throw error;
    }
  }

  static Future<bool> esFavorito(
      BuildContext context, String foodId) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      final nick = globales.nick;

      final userFavoritesDocRef =
          FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);

      final userFoodCollectionRef =
          userFavoritesDocRef.collection('Alimentos');

      final foodDocSnapshot =
          await userFoodCollectionRef.doc(foodId).get();
      return foodDocSnapshot.exists;
    } catch (error) {
      print('Error al verificar si el alimento es favorito: $error');
      throw error;
    }
  }

  static Stream<List<Food>> obtenerTodosAlimentosStream(
      BuildContext context) {
    final StreamController<List<Food>> controller =
        StreamController<List<Food>>();

    try {
      final foodCollectionRef =
          FirebaseFirestore.instance.collection('Alimentos');
      final StreamSubscription<QuerySnapshot> subscription =
          foodCollectionRef.snapshots().listen((QuerySnapshot snapshot) {
        final List<Food> foods =
            snapshot.docs.map((DocumentSnapshot doc) {
          final food = Food.fromFirestore(doc);
          food.id = doc.id;
          return food;
        }).toList();
        controller.add(foods);
      }, onError: (error) {
        print('Error al obtener stream de alimentos: $error');
        controller.addError(error);
      });

      controller.onCancel = () {
        subscription.cancel();
      };

      return controller.stream;
    } catch (error) {
      print('Error al obtener stream de alimentos: $error');
      throw error;
    }
  }

  static Future<Food?> obtenerAlimentoPorId(
      BuildContext context, String foodId) async {
    try {
      final foodDoc = await FirebaseFirestore.instance
          .collection('Alimentos')
          .doc(foodId)
          .get();
      if (foodDoc.exists) {
        final food = Food.fromFirestore(foodDoc);
        food.id = foodDoc.id;
        return food;
      } else {
        return null;
      }
    } catch (error) {
      print('Error al obtener alimento por ID: $error');
      throw error;
    }
  }
}
