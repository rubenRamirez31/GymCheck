import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';

class DataNutritionalTracking extends StatelessWidget {
  final IconData icon;
  final String name;
  final double data;
  final double meta;
  final VoidCallback verMas;
  final VoidCallback agregar;
  final VoidCallback quitar;

  DataNutritionalTracking({
    required this.icon,
    required this.name,
    required this.data,
    required this.meta,
    required this.verMas,
    required this.agregar,
    required this.quitar,
  });

  @override
  Widget build(BuildContext context) {
    double percentComplete = (data / meta).clamp(0.0, 1.5);

    Color progressBarColor = Colors.blue;
    if (percentComplete > 1.4) {
      progressBarColor = Colors.red;
    } else if (percentComplete > 1.2) {
      progressBarColor = Colors.orange;
    } else if (percentComplete > 0.90) {
      progressBarColor = Colors.green;
    } else {
      progressBarColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 40, 40, 40),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            icon,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            'Cantidad:',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ' $data gr',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                         const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.flag, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            'Meta:',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ' $meta gr',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [

                     CustomButton(
                  onPressed: verMas,
                  text: 'Ver más',
                  icon: Icons.table_rows_rounded,
                ),
                 Row(
                   children: [
                     CustomButton(
                          onPressed: quitar,
                          text: '',
                          icon: Icons.add,
                        ),
                        SizedBox(width:5,),
                     CustomButton(
                          onPressed: agregar,
                          text: '',
                          icon: Icons.remove,
                        ),
                   ],
                 ),
                   
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            const SizedBox(height: 10),
                        Stack(
              children: [
                Container(
                  height: 20, // Ajustar la altura de la barra de progreso
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    color: Colors.grey[800], // Color de fondo de la barra
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentComplete / 1.5,
                  child: Container(
                    height: 20, // Ajustar la altura de la barra de progreso
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                      color: progressBarColor, // Color de la barra de progreso
                    ),
                  ),
                ),
                Positioned(
                  left: 210, // Ajustar la posición del icono de la bandera
                  top: -15, // Ajustar la posición vertical del icono de la bandera
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Meta: $meta gr',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: const Color.fromARGB(
                              255, 255, 255, 255), // Fondo de la etiqueta
                          behavior: SnackBarBehavior
                              .floating, // Hace que la etiqueta flote sobre la pantalla
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.flag,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
       
                    // CustomButton(
                    //   onPressed: quitar,
                    //   text: 'Quitar',
                    //   icon: Icons.remove,
                    // ),
                    //          CustomButton(
                    //   onPressed: agregar,
                    //   text: 'Agregar',
                    //   icon: Icons.add,
                    // ),
                    //SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
