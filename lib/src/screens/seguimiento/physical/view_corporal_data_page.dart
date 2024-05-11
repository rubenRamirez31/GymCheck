import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa DateFormat

class ViewCorporalDataPage extends StatefulWidget {
  final String data;
  final String coleccion;

  ViewCorporalDataPage({required this.data, required this.coleccion});

  @override
  _ViewCorporalDataPageState createState() => _ViewCorporalDataPageState();
}

class _ViewCorporalDataPageState extends State<ViewCorporalDataPage> {
  List<Map<String, dynamic>> weightRecords = [];

  String _orderByMensaje = '';
  String _coleccion = '';
  String _orderBy = '';
  String _orderByDirection = '';
  String _typeData = 'si';
  List<double> graphData = [];

  final List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: Colors.blue,
      data: [0.2, 0.8, 0.4, 0.7, 0.6, 0.9, 0.91, 0.92, 0.93, 0.94],
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadSavedData() async {
    _coleccion = widget.coleccion;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _orderByMensaje =
          prefs.getString('orderByMensaje') ?? 'Fecha más reciente';
      _orderBy = prefs.getString('orderBy') ?? 'fecha';
      _orderByDirection = prefs.getString('orderByDirection') ?? 'desc';
      _typeData = prefs.getString('typeData') ?? widget.data.toLowerCase();

      if (_orderBy == 'fecha') {
        _typeData = widget.data.toLowerCase();
        _orderByMensaje = _orderByDirection == 'desc'
            ? 'Fecha más reciente'
            : 'Fecha más antigua';
      } else {
        _orderBy = widget.data.toLowerCase();
        _typeData = widget.data.toLowerCase();
        _orderByMensaje = _orderByDirection == 'desc'
            ? 'Mayor $_typeData'
            : 'Menor $_typeData';
      }
    });
    fetchData();
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
    weightRecords.forEach((entry) {
      // Añade el valor del tipo de dato al gráfico (puedes ajustar el campo dependiendo de tu estructura de datos)
      graphData.add(entry[_typeData]);
    });
    return Scaffold(
      // backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () => showSortMenu(context),
                ),
                Text(_orderByMensaje),
              ],
            ),
            const SizedBox(height: 5),
            buildDataTable(),
            const SizedBox(height: 5),
            Container(),
            Container(
              width: MediaQuery.of(context).size.width - 10,
              height: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              //color: Colors.black,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: LineGraph(
                  features: features,
                  size: Size(320, 400),
                  labelX: [
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '1',
                    '2',
                    '3',
                    '4',
                    '5'
                  ],
                  labelY: ['20%', '40%', '60%', '80%', '100%'],
                  showDescription: true,
                  graphColor: Colors.white30,
                  graphOpacity: 0.2,
                  verticalFeatureDirection: true,
                  descriptionHeight: 130,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Fecha de registro')),
            DataColumn(label: Text('Valor')),
          ],
          rows: weightRecords.map((entry) {
            return DataRow(cells: [
              DataCell(Text(widget.data)),
              DataCell(Text(entry['fecha'] ?? '')),
              DataCell(Text(entry[_typeData].toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // Método para obtener etiquetas X
  List<String> _getXLabels() {
    List<String> labels = [];
    weightRecords.forEach((entry) {
      labels.add(entry['fecha']); // Agrega las fechas de weightRecords
    });
    return labels;
  }

  // Método para obtener etiquetas Y
  List<String> _getYLabels() {
    List<String> labels = [];
    weightRecords.forEach((entry) {
      labels.add(
          entry[_typeData].toString()); // Agrega las fechas de weightRecords
    });
    return labels;
  }

  void showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 275,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ordenar Por',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            buildSortListTile('Fecha más reciente', 'fecha', 'desc'),
            buildSortListTile('Fecha más antigua', 'fecha', 'asc'),
            buildSortListTile(
                'Mayor $_typeData', widget.data.toLowerCase(), 'desc'),
            buildSortListTile(
                'Menor $_typeData', widget.data.toLowerCase(), 'asc'),
          ],
        ),
      ),
    );
  }

  ListTile buildSortListTile(String title, String orderBy, String direction) {
    return ListTile(
      title: Text(title),
      onTap: () {
        setState(() {
          _orderByMensaje = title;
          _orderBy = orderBy;
          _orderByDirection = direction;
        });
        Navigator.pop(context);
        fetchData();
      },
    );
  }

  void fetchData() async {
    try {
      final response = await PhysicalDataService.getDataWithDynamicSorting(
        context,
        _coleccion,
        _orderBy,
        _orderByDirection,
        _typeData,
      );

      setState(() {
        weightRecords = response;
      });
    } catch (error) {
      print('Error al obtener datos físicos con ordenamiento dinámico: $error');
    }
  }
}
