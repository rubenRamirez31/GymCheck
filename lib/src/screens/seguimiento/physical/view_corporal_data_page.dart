import 'package:flutter/material.dart';
import 'package:gym_check/src/environments/environment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCorporalDataPage extends StatefulWidget {
  final String data;

  ViewCorporalDataPage({required this.data});

  @override
  _ViewCorporalDataPageState createState() => _ViewCorporalDataPageState();
}

class _ViewCorporalDataPageState extends State<ViewCorporalDataPage> {
  List<Map<String, dynamic>> weightRecords = [];

  String _orderByMensaje = '';
  String _orderBy = '';
  String _orderByDirection = '';
  String _typeData = '';

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //Valores por defectos en una primera instancia
      _orderByMensaje =
          prefs.getString('orderByMensaje') ?? 'Fecha más reciente';
      _orderBy= prefs.getString('orderBy') ?? 'fecha';
      _orderByDirection = prefs.getString('orderByDirection') ?? 'desc';
      _typeData = prefs.getString('typeData') ?? widget.data.toLowerCase();

      //Logica de cambio dependiendo el dato que se ve
      if (_orderBy== 'fecha') {
        _typeData = widget.data.toLowerCase();
        if (_orderByDirection == 'desc') {
          _orderByMensaje = 'Fecha más reciente';
        }
        if (_orderByDirection == 'asc') {
          _orderByMensaje = 'Fecha más antigua';
        }
      } else {
        _orderBy = widget.data.toLowerCase();
        _typeData = widget.data.toLowerCase();
        if (_orderByDirection == 'desc') {
          _orderByMensaje = 'Mayor $_typeData';
        }
        if (_orderByDirection == 'asc') {
          _orderByMensaje = 'Menor $_typeData';
        }
      }
    });
    fetchData(); // Llama a la función para obtener datos
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('orderByMensaje', _orderByMensaje);
    prefs.setString('orderBy', _orderBy);
    prefs.setString('orderByDirection', _orderByDirection);
    prefs.setString('typeData', _typeData);
  }

  @override
  void dispose() {
    saveData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    // Mostrar el menú de opciones de ordenamiento
                    showSortMenu(context);
                  },
                ),
                Text(_orderByMensaje), // Muestra el texto del orden actual
                //SizedBox(width: 1, height: 1)
              ],
            ),
            const SizedBox(height: 5),
            Container(
              width: screenSize.width - 10,
              height: 400,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Fecha de registro')),
                    DataColumn(label: Text('peso')),
                  ],
                  rows: weightRecords.map((entry) {
                    return DataRow(cells: [
                      DataCell(Text(widget.data)),
                      DataCell(Text(entry['fecha'] ?? '')),
                      DataCell(Text(entry['$_typeData'].toString() ?? '')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: screenSize.width - 10,
              height: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.amber,
              ),
              // Aquí puedes colocar tu gráfico
            ),
          ],
        ),
      ),
    );
  }

void showSortMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SizedBox(
      height: 275, // Altura del menú
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ordenar Por',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text('Fecha más reciente'),
            onTap: () {
              // Cierra el menú y actualiza el estado con la nueva ordenación
              setState(() {
                _orderByMensaje = 'Fecha más reciente';
                _orderBy = 'fecha';
                _orderByDirection = "desc";
                _typeData = widget.data.toLowerCase();
              });
              Navigator.pop(context);
              fetchData(); // Llama a fetchData para obtener los datos con el nuevo ordenamiento
            },
          ),
          ListTile(
            title: const Text('Fecha más antigua'),
            onTap: () {
              // Cierra el menú y actualiza el estado con la nueva ordenación
              setState(() {
                _orderByMensaje = 'Fecha más antigua';
                _orderBy = 'fecha';
                _orderByDirection = "asc";
                _typeData = widget.data.toLowerCase();
              });
              Navigator.pop(context);
              fetchData(); // Llama a fetchData para obtener los datos con el nuevo ordenamiento
            },
          ),
          ListTile(
            title: Text('Mayor $_typeData'),
            onTap: () {
              // Cierra el menú y actualiza el estado con la nueva ordenación
              setState(() {
                _orderByMensaje = 'Mayor $_typeData';
                _orderBy = widget.data.toLowerCase();
                _orderByDirection = "desc";
                _typeData = widget.data.toLowerCase();
              });
              Navigator.pop(context);
              fetchData(); // Llama a fetchData para obtener los datos con el nuevo ordenamiento
            },
          ),
          ListTile(
            title: Text('Menor $_typeData'),
            onTap: () {
              // Cierra el menú y actualiza el estado con la nueva ordenación
              setState(() {
                _orderByMensaje = 'Menor $_typeData';
                _orderBy = widget.data.toLowerCase();
                _orderByDirection = "asc";
                _typeData = widget.data.toLowerCase();
              });
              Navigator.pop(context);
              fetchData(); // Llama a fetchData para obtener los datos con el nuevo ordenamiento
            },
          ),
        ],
      ),
    ),
  );
}


  // Función para obtener datos desde el servidor
  void fetchData() async {
    String userId = 'meendy'; // Agrega el ID de usuario
    String collectionType = 'Registro-Corporal'; // Agrega el tipo de colección
    String orderByField = _typeData; 
    String orderBy = _orderBy;
    String orderByDirection = _orderByDirection;

    String apiUrl = '${Environment.API_URL}/api/datos-fisicos/obtener-datos/$userId/$collectionType/$orderByField/$orderBy/$orderByDirection';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        List<Map<String, dynamic>> formattedData = (result['data'] as List<dynamic>).cast<Map<String, dynamic>>();
        setState(() {
          weightRecords = formattedData;
        });
      } else {
        print('Error en la solicitud: ${response.body}');
      }
    } catch (error) {
      print('Error al obtener datos desde el servidor: $error');
    }
  }
}
