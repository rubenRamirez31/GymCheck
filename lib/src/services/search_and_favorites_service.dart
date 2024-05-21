// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gym_check/src/providers/globales.dart';
// import 'package:provider/provider.dart';

// class SearchAndFavoritesService<T> {
//   final String collectionName;

//   SearchAndFavoritesService(this.collectionName);

//   Future<void> agregarAFavoritos(BuildContext context, T item) async {
//     try {
//       Globales globales = Provider.of<Globales>(context, listen: false);
//       final nick = globales.nick;
//       final userFavoritesDocRef =
//           FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);
//       final userItemCollectionRef =
//           userFavoritesDocRef.collection(collectionName);
//       final existingItem = await userItemCollectionRef.doc(item.id).get();
//       if (existingItem.exists) {
//         print('Este item ya está en favoritos.');
//         return;
//       }
//       await userItemCollectionRef.doc(item!.id).set({
//         'id': item.id,
//         'name': item.name,
//         // Agrega aquí cualquier otro dato que desees guardar
//       });
//       print('$collectionName agregado a favoritos con éxito.');
//     } catch (error) {
//       print('Error al agregar el $collectionName a favoritos: $error');
//       throw error;
//     }
//   }

//   Future<void> quitarDeFavoritos(
//       BuildContext context, String itemId) async {
//     try {
//       Globales globales = Provider.of<Globales>(context, listen: false);
//       final nick = globales.nick;
//       final userFavoritesDocRef =
//           FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);
//       final userItemCollectionRef =
//           userFavoritesDocRef.collection(collectionName);
//       final existingItem = await userItemCollectionRef.doc(itemId).get();
//       if (!existingItem.exists) {
//         print('Este $collectionName no está en favoritos.');
//         return;
//       }
//       await userItemCollectionRef.doc(itemId).delete();
//       print('$collectionName eliminado de favoritos con éxito.');
//     } catch (error) {
//       print('Error al quitar el $collectionName de favoritos: $error');
//       throw error;
//     }
//   }

//   Future<bool> esFavorito(
//       BuildContext context, String itemId) async {
//     try {
//       Globales globales = Provider.of<Globales>(context, listen: false);
//       final nick = globales.nick;
//       final userFavoritesDocRef =
//           FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);
//       final userItemCollectionRef =
//           userFavoritesDocRef.collection(collectionName);
//       final itemDocSnapshot =
//           await userItemCollectionRef.doc(itemId).get();
//       return itemDocSnapshot.exists;
//     } catch (error) {
//       print('Error al verificar si el $collectionName es favorito: $error');
//       throw error;
//     }
//   }

//   Stream<List<T>> obtenerFavoritosFiltradosStream(
//       BuildContext context, String query,
//       {String? enfoque}) {
//     final StreamController<List<T>> controller =
//         StreamController<List<T>>();

//     try {
//       Globales globales = Provider.of<Globales>(context, listen: false);
//       final nick = globales.nick;
//       final userFavoritesDocRef =
//           FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);
//       final userItemCollectionRef =
//           userFavoritesDocRef.collection(collectionName);

//       Query filteredQuery = userItemCollectionRef.where(
//         'name',
//         isGreaterThanOrEqualTo: query,
//         isLessThanOrEqualTo: query + '\uf8ff',
//       );

//       if (enfoque != null) {
//         filteredQuery = filteredQuery.where('primaryFocus', isEqualTo: enfoque);
//       }

//       final StreamSubscription<QuerySnapshot> subscription =
//           filteredQuery.snapshots().listen((QuerySnapshot snapshot) async {
//         final List<T> filteredItems = [];
//         for (final doc in snapshot.docs) {
//           final itemId = doc.id;
//           final item = await getItemById(context, itemId);
//           if (item != null) {
//             filteredItems.add(item);
//           }
//         }
//         controller.add(filteredItems);
//       }, onError: (error) {
//         print('Error al obtener $collectionName filtrados favoritos: $error');
//         controller.addError(error);
//       });

//       controller.onCancel = () {
//         subscription.cancel();
//       };

//       return controller.stream;
//     } catch (error) {
//       print('Error al obtener $collectionName filtrados favoritos: $error');
//       throw error;
//     }
//   }

//   Future<T?> getItemById(BuildContext context, String itemId) async {
//     try {
//       final itemDocSnapshot =
//           await FirebaseFirestore.instance.collection(collectionName).doc(itemId).get();
//       if (itemDocSnapshot.exists) {
//         final item = T.fromFirestore(itemDocSnapshot);
//         return item;
//       }
//       return null;
//     } catch (error) {
//       print('Error al obtener $collectionName por ID: $error');
//       throw error;
//     }
//   }
// }
