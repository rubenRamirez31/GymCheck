import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/seguimiento/physical/add_data_page.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/create_button_widget.dart';
import 'package:gym_check/src/widgets/seguimiento/data_tracking_widget.dart';
import 'package:provider/provider.dart';

class BodyDataTrackingPage extends StatefulWidget {
  @override
  _BodyDataTrackingPageState createState() => _BodyDataTrackingPageState();
}

class _BodyDataTrackingPageState extends State<BodyDataTrackingPage> {
  String _nick = '';
  int _peso = 0;
  int _altura = 0;
  int _grasa = 0;
  int _circuferencia = 0;
  String _fecha = "";
  String _coleccion = 'Registro-Diario';

  @override
  void initState() {
    super.initState();
    _loadUserDataLastDataPhysical();
  }

  Future<void> _loadUserDataLastDataPhysical() async {
    try {
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      setState(() {
        _nick = userData['nick'];
      });

      Map<String, dynamic> dataPhysical =
          await PhysicalDataService.getLatestPhysicalData(_nick, _coleccion);
      setState(() {
        _peso = dataPhysical['peso'];
        _altura = dataPhysical['altura'];
        _grasa = dataPhysical['grasaCorporal'];
        _circuferencia = dataPhysical['circunferenciaCintura'];
        _fecha = dataPhysical['fecha'];
      });
      print("Holaaaaaaaaa" + _peso.toString());
      print("Holaaaaaaaaa" + _nick);
      print("Holaaaaaaaaa" + _coleccion);
      print("Holaaaaaaaaa" + _fecha);
    } catch (error) {
      print('Error loading user physical data: $error');
      print(_nick);
      print(_coleccion);
    }
  }

  Widget _DatosCoporalesWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Mis Registros',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(Icons.info), // Botón de búsqueda
              onPressed: () {
                // Acción al presionar el botón de búsqueda
              },
            ),
          ],
        ),
        CreateButton(
          text: 'Agregar',
          buttonColor: Colors.green,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddDataPage()),
            );
          },
          iconData: Icons.add,
          iconColor: Colors.white, // Color del ícono
          secondaryButtons: [
            SecondaryButton(
              text: "1",
              buttonColor: Colors.red,
              iconData: Icons.delete,
              iconColor: Colors.white,
              onPressed: () {
                // Acción al presionar el botón secundario
              },
            ),
            SecondaryButton(
              text: "2",
              buttonColor: Colors.green,
              iconData: Icons.edit,
               iconColor: Colors.white,
              onPressed: () {
                // Acción al presionar el botón secundario
              },
            ),
            // Puedes agregar más botones secundarios según sea necesario
          ],
        ),
        SizedBox(height: 10),
        SizedBox(),
        SizedBox(
          height: 300,
          // Establece el tamaño máximo que deseas para el ScrollView
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Últimos datos registrados: ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14, // Tamaño de letra más pequeño
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: DataTracking(
                    icon: Icons.accessibility,
                    name: 'Peso',
                    dataType: 'Kilogramos:',
                    data: _peso.toString(),
                    lastRecordDate: _fecha, // Última fecha de registro
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: DataTracking(
                    icon: Icons.height,
                    name: 'Altura',
                    dataType: 'Centimetros:',
                    data: _altura.toString(),
                    lastRecordDate: '2024-03-31', // Última fecha de registro
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: DataTracking(
                    icon: Icons.circle,
                    name: 'Circunferencia de Cintura',
                    dataType: 'Centímetros:',
                    data: _circuferencia.toString(),
                    lastRecordDate: '2024-03-31', // Última fecha de registro
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: DataTracking(
                    icon: Icons.opacity,
                    name: 'Grasa Corporal',
                    dataType: 'Porcentaje:',
                    data: _grasa.toString() + "%",
                    lastRecordDate: '2024-03-31', // Última fecha de registro
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Analizar informacion corporal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(Icons.info), // Botón de búsqueda
              onPressed: () {
                // Acción al presionar el botón de búsqueda
              },
            ),
          ],
        ),
        Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DatosCoporalesWidget();
  }
}
