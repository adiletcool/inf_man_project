import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inf_man_project/HexColor.dart';
import 'package:inf_man_project/dataModel.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor.fromHex('#4b89ac'),
        title: Text('COVID-19', style: TextStyle(fontSize: 25)),
        centerTitle: true,
      ),
      body: Stack(children: <Widget>[
        MySfMap(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              DropdownSearch<String>(
                mode: Mode.MENU,
                showSelectedItem: true,
                items: countriesList,
                label: "Location",
                showSearchBox: true,
                dropdownBuilder: (context, item, isSelected) => Text(item, style: TextStyle(fontSize: 23)),
                dropdownSearchDecoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  hoverColor: Colors.red,
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => print(value),
                selectedItem: "Russia",
                maxHeight: MediaQuery.of(context).size.height / 2,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class MySfMap extends StatefulWidget {
  const MySfMap();

  @override
  _MySfMapState createState() => _MySfMapState();
}

class _MySfMapState extends State<MySfMap> {
  MapShapeLayerDelegate _mapShapeDelegate;
  List<CovidTotalDataModel> _covidTotalData;
  List<MapColorMapper> _colorMappers;
  MapZoomPanBehavior _zoomPanBehavior;

  Future<bool> asyncInit() async {
    _zoomPanBehavior = MapZoomPanBehavior(maxZoomLevel: 7);
    _covidTotalData = await getTotalData();

    _colorMappers = [
      MapColorMapper(from: 0, to: 9999, color: HexColor.fromHex('#ffd460')),
      MapColorMapper(from: 10000, to: 99999, color: HexColor.fromHex('#f07b3f')),
      MapColorMapper(from: 100000, to: 499999, color: HexColor.fromHex('#ea5455')),
      MapColorMapper(from: 500000, to: 999999, color: HexColor.fromHex('#973961')),
      MapColorMapper(from: 1000000, to: 1499999, color: HexColor.fromHex('#623448')),
      MapColorMapper(from: 1500000, to: 1999999, color: HexColor.fromHex('#36162e')),
      MapColorMapper(from: 2000000, to: 3000000, color: HexColor.fromHex('#200f21')),
      MapColorMapper(from: 5000000, to: 5000002, color: HexColor.fromHex('#200f21')),
    ];

    _mapShapeDelegate = MapShapeLayerDelegate(
      shapeFile: 'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: _covidTotalData.length,
      primaryValueMapper: (int index) => _covidTotalData[index].countryName,
      shapeTooltipTextMapper: (int index) {
        return 'Country : ' +
            (_covidTotalData[index].countryName) +
            '\nActive: ' +
            _covidTotalData[index].active.toString() +
            '\nRecovered: ' +
            _covidTotalData[index].recovered.toString() +
            '\nDeaths: ' +
            _covidTotalData[index].deaths.toString() +
            '\nTotal: ' +
            _covidTotalData[index].total.toString();
      },
      shapeColorValueMapper: (int index) => _covidTotalData[index].active,
      shapeColorMappers: _colorMappers,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) return Center(child: CircularProgressIndicator());
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: SfMaps(
            layers: <MapShapeLayer>[
              MapShapeLayer(
                // shapeTooltipBuilder: (context, index) => Container(color: Colors.red),
                delegate: _mapShapeDelegate,
                enableShapeTooltip: true,
                zoomPanBehavior: _zoomPanBehavior,
              )
            ],
          ),
        );
      },
    );
  }
}
