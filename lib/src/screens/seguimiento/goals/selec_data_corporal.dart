import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/seguimiento/goals/create_macros_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/add_data_page.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:provider/provider.dart';

class DatosCorporalesPage extends StatefulWidget {
  final String tipoMeta;
  final double tdee;

  const DatosCorporalesPage(
      {Key? key, required this.tipoMeta, required this.tdee})
      : super(key: key);

  @override
  _DatosCorporalesPageState createState() => _DatosCorporalesPageState();
}

class _DatosCorporalesPageState extends State<DatosCorporalesPage> {
  double peso = 0;
  double altura = 0;
  int edad = 21;
  String sexo = 'masculino';
  final String _coleccion = 'Registro-Corporal';

  final Map<String, String> _datos = {
    'peso': 'Kilogramos:',
    'altura': 'Centimetros:',
  };

  @override
  void initState() {
    super.initState();
    // Cargar los datos corporales existentes del usuario al iniciar la página
    _loadUserDataLastDataPhysical();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Datos Corporales',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        //color: const Color.fromARGB(255, 18, 18, 18),
        child: Container(
          color: const Color.fromARGB(255, 18, 18, 18),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Se utilizarán los últimos datos registrados para calcular tus macros.',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),

              const SizedBox(height: 20),
              // Agregar campos de entrada para peso, altura, edad y sexo
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 83, 83, 83),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Peso (kg):',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      peso.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        _showAddData(context);
                      },
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 83, 83, 83),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Altura (cm):',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      altura.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        _showAddData(context);
                      },
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Verificar si falta algún dato
          if (peso <= 0 || altura <= 0 || edad <= 0 || sexo.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Por favor, ingresa todos los datos requeridos.'),
              ),
            );
          } else {
            // Todos los datos están presentes, continuar con el cálculo
            // Llamar a la función para obtener los datos corporales
            Map<String, dynamic> datosCorporales =
                await obtenerDatosCorporales();

            // Mostrar un AlertDialog antes de cambiar de página
            // ignore: use_build_context_synchronously
  showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: Text(
             'Creando tus macros...',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white), // Color del indicador de progreso blanco
            ),
          );
        },
      );

            // Simular una demora de 2 segundos para la carga
            await Future.delayed(const Duration(seconds: 2));

            // Cerrar el AlertDialog
            Navigator.of(context).pop();

            // Navegar a la página CreateMatricesPage con los datos corporales obtenidos
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateMatricesPage(
                  datosCorporales: datosCorporales,
                  tipoMeta: widget.tipoMeta,
                ),
              ),
            );
          }
        },
        // Resto del FloatingActionButton

        backgroundColor: const Color(0xff0C1C2E),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Future<void> _loadUserDataLastDataPhysical() async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);

      setState(() {
        sexo = globales.genero;
        // edad = globales.;
      });

      for (String dato in _datos.keys) {
        Map<String, dynamic> data =
            await PhysicalDataService.getLatestPhysicalData(
                context, _coleccion, dato);
        setState(() {
          switch (dato) {
            case 'peso':
              peso = data['peso'] ?? 0;

              break;
            case 'altura':
              altura = data['altura'] ?? 0;

              break;
          }
        });
      }
    } catch (error) {
      print('Error loading user physical data: $error');
    }
  }

  void _showAddData(BuildContext context) {
    showModalBottomSheet(
      backgroundColor:  Color.fromARGB(255, 18, 18, 18),
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.60,
          child: AddDataPage(tipoDeRegistro: "corporales", goal: true,),
        );
      },
    );
  }

  Future<Map<String, dynamic>> obtenerDatosCorporales() async {
    // Hombres: BMR = 10 x peso (kg) + 6.25 x altura (cm) - 5 x edad (años) + 5
    //Mujeres: BMR = 10 x peso (kg) + 6.25 x altura (cm) - 5 x edad (años) - 161
    // Aquí puedes usar los datos actuales del usuario para calcular los datos corporales
    // Por ahora, estoy usando los datos predeterminados para simular el cálculo
    final double tmb = 10 * peso + 6.25 * altura - 5 * edad + 5;
    final double tdee =
        tmb * widget.tdee; // Utilizando una PAL predeterminada de 2.2

    // Crear el mapa de datos corporales y devolverlo
    Map<String, dynamic> datosCorporalesCalculados = {
      'peso': peso,
      'altura': altura,
      'edad': edad,
      'sexo': sexo,
      'tdee': tdee,
      // Asegúrate de agregar otros datos corporales necesarios
    };

    return datosCorporalesCalculados;
  }
}
