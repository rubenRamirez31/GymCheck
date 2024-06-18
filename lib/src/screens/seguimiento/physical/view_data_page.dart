import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa DateFormat

class ViewCorporalDataPage extends StatefulWidget {
  final String data;
  final String coleccion;
  final String tipo;

  ViewCorporalDataPage({required this.data, required this.coleccion, required this.tipo});

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
      _typeData = prefs.getString('typeData') ?? widget.data;

      if (_orderBy == 'fecha') {
        _typeData = widget.data;
        _orderByMensaje = _orderByDirection == 'desc'
            ? 'Fecha más reciente'
            : 'Fecha más antigua';
      } else {
        _orderBy = 'valor';
        _typeData = widget.data;
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
  for (var entry in weightRecords) {
    // Añade el valor del tipo de dato al gráfico (puedes ajustar el campo dependiendo de tu estructura de datos)
    graphData.add(entry[widget.tipo]);
  }
return Scaffold(
    backgroundColor: const Color.fromARGB(255, 18, 18, 18),
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor:  const Color.fromARGB(255, 18, 18, 18),
          shadowColor: const Color.fromARGB(255, 18, 18, 18),
          foregroundColor: const Color.fromARGB(255, 18, 18, 18),
          surfaceTintColor: const Color.fromARGB(255, 18, 18, 18),
          elevation: 0,
          pinned: true,
           automaticallyImplyLeading: false,
          // Esto hace que el SliverAppBar se quede fijo en la parte superior
          floating: false,
          title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.sort),
                    onPressed: () => showSortMenu(context),
                    color: Colors.white,
                  ),
                  Text(
                _orderByMensaje,
                style: const TextStyle(color: Colors.white, fontSize: 16), // Cambia el tamaño de la letra
              ),
                ],
              ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.data,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
                buildDataTable(),
                const SizedBox(height: 15),
                const Text(
                  'Gráfica',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              height: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: buildChartFecha(),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 50),
        ),
      ],
    ),
  );
}

Widget buildDataTable() {
  return SizedBox(
    height: 350,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: DataTable(
              columns:  const [
                DataColumn(label: Text('Fecha de registro', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Valor', style: TextStyle(color: Colors.white))),
              ],
              rows: weightRecords.map((entry) {
                return DataRow(cells: [
                  DataCell(Text(entry['fecha'] ?? '', style: const TextStyle(color: Colors.white))),
                  DataCell(Text(entry['valor'].toString(), style: const TextStyle(color: Colors.white))),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    ),
  );
}




  Widget buildChartFecha() {
     //if(widget.coleccion == "Registro-Corporal") _typeData = _typeData.toLowerCase();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SfCartesianChart(
        

        
        
        primaryXAxis: const CategoryAxis(  labelRotation: 90, labelStyle: TextStyle(color: Colors.white),),
       primaryYAxis: const NumericAxis(labelStyle: TextStyle(color: Colors.white),),
            
        series: <CartesianSeries>[
          LineSeries<Map<String, dynamic>, String>(
            dataSource: weightRecords,
            xValueMapper: (entry, _) => entry['fecha'] as String,
            yValueMapper: (entry, _) => entry['valor'] as double,
          )
        ],
      
      
      
      ),



    );
  }



  void showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) => SizedBox(
        height: 275,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ordenar Por',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            buildSortListTile('Fecha más reciente', 'fecha', 'desc'),
            buildSortListTile('Fecha más antigua', 'fecha', 'asc'),
            buildSortListTile(
                'Mayor $_typeData', 'valor', 'desc'),
            buildSortListTile(
                'Menor $_typeData', 'valor', 'asc'),
          ],
        ),
      ),
    );
  }

  ListTile buildSortListTile(String title, String orderBy, String direction) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
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
      if(widget.coleccion == "Registro-Corporal") _typeData = _typeData.toLowerCase();
      print('widget.tipo');
      print(widget.tipo);
       print('widget.tipo');
       print('_orderBy');
       print(_orderBy);
       print('_orderBy');
    
      final response = await PhysicalDataService.getDataWithDynamicSorting(
        context,
        _coleccion,
        _orderBy,
        _orderByDirection,
        widget.tipo,
      );

      setState(() {
        weightRecords = response;
        print("object");
        print(_coleccion);
        print(_orderBy);
        print(_orderByDirection);
        print(_typeData);
        
        print(weightRecords.toList());
        
      });
    } catch (error) {
      print('Error al obtener datos físicos con ordenamiento dinámico: $error');
    }
  }
}
