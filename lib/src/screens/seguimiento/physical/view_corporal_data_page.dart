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
                  onPressed: () => showSortMenu(context),
                ),
                Text(_orderByMensaje),
              ],
            ),
            const SizedBox(height: 5),
            buildDataTable(),
            const SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width - 10,
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
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      String nick = userData['nick'];
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
