import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inf_man_project/HexColor.dart';
import 'package:inf_man_project/dataModel.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:intl/intl.dart';
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
  String selectedDDLocation = 'World';
  String selectedMapLocation;
  @override
  void initState() {
    super.initState();
  }

  Widget getCountryDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width / 6,
      padding: const EdgeInsets.all(12.0),
      child: DropdownSearch<String>(
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
        onChanged: (value) {
          selectedDDLocation = value;
          print(selectedDDLocation);
          setState(() {});
        },
        selectedItem: selectedDDLocation,
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        MySfMap(selectedDDLocation),
        getCountryDropdown(),
      ]),
    );
  }
}

class MySfMap extends StatefulWidget {
  const MySfMap(this.location);
  final String location;
  @override
  _MySfMapState createState() => _MySfMapState(location);
}

class _MySfMapState extends State<MySfMap> {
  _MySfMapState(this.location);
  final String location;

  MapShapeLayerDelegate _mapShapeDelegate;
  List<CovidTotalDataModel> _covidTotalData;
  final MapZoomPanBehavior _zoomPanBehavior = MapZoomPanBehavior(maxZoomLevel: 7, toolbarSettings: MapToolbarSettings(direction: Axis.vertical));
  var formatter = NumberFormat('###,000');
  List<MapColorMapper> _colorMappers = myColorMappers;
  String selectedMapLocation;
  MapShapeLayerController mapController = MapShapeLayerController();

  Future<bool> asyncInit() async {
    _covidTotalData = await getTotalData();

    _mapShapeDelegate = MapShapeLayerDelegate(
      shapeFile: 'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: _covidTotalData.length,
      primaryValueMapper: (int index) => _covidTotalData[index].countryName,
      shapeTooltipTextMapper: (int index) {
        String countryName = _covidTotalData[index].countryName;
        if (selectedMapLocation != _covidTotalData[index].countryName) selectedMapLocation = _covidTotalData[index].countryName;

        return 'Country : ' +
            countryName +
            '\nActive: ' +
            formatter.format(_covidTotalData[index].active) +
            '\nRecovered: ' +
            formatter.format(_covidTotalData[index].recovered) +
            '\nDeaths: ' +
            formatter.format(_covidTotalData[index].deaths) +
            '\nTotal: ' +
            formatter.format(_covidTotalData[index].total);
      },
      shapeColorValueMapper: (int index) => _covidTotalData[index].active,
      shapeColorMappers: _colorMappers,
    );
    return true;
  }

  void showParamsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => myBottomSheet(),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
    ).then((value) => mapController.selectedIndex = -1);
  }

  Widget myBottomSheet() {
    return Container(
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
          color: HexColor.fromHex('#efecec').withOpacity(.7),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          right: 15,
          left: 15,
          bottom: (MediaQuery.of(context).viewInsets.bottom == 0) ? 15 : MediaQuery.of(context).viewInsets.bottom + 5,
        ),
        child: Container(
          child: Text(selectedMapLocation, style: TextStyle(fontSize: 26)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) return Center(child: CircularProgressIndicator());
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: GestureDetector(
            onTap: () {
              var index = mapController.selectedIndex;
              if (index != -1) showParamsBottomSheet();
            },
            child: SfMaps(
              layers: <MapShapeLayer>[
                MapShapeLayer(
                  delegate: _mapShapeDelegate,
                  enableSelection: true,
                  controller: mapController,
                  selectionSettings: MapSelectionSettings(
                    color: HexColor.fromHex('#085f63'),
                    strokeWidth: 3,
                    strokeColor: HexColor.fromHex('#293462'),
                  ),
                  tooltipSettings: MapTooltipSettings(
                    color: HexColor.fromHex('#303a52'),
                    textStyle: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  enableShapeTooltip: true,
                  zoomPanBehavior: _zoomPanBehavior,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
