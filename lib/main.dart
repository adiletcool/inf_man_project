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
      theme: ThemeData(fontFamily: 'ALS_Sector'),
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
  List<String> mapperAvailable = ['Active', 'Total', 'Recovered', 'Deaths'];
  String shapeColorMapper;

  @override
  void initState() {
    super.initState();
    shapeColorMapper = mapperAvailable[0];
  }

  void setNextMapper() {
    int nextId = mapperAvailable.indexOf(shapeColorMapper) + 1;
    if (nextId > mapperAvailable.length - 1) nextId -= mapperAvailable.length;
    shapeColorMapper = mapperAvailable[nextId];
    setState(() {});
  }

  Widget getCountryDropdown() {
    return Container(
      width: 350, // MediaQuery.of(context).size.width / 6,
      padding: const EdgeInsets.only(top: 20, left: 15),
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSelectedItem: true,
        items: countriesList,
        label: "Location",
        showSearchBox: true,
        dropdownBuilder: (context, item, isSelected) => Text(item, style: TextStyle(fontSize: 23)),
        dropdownSearchDecoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          contentPadding: EdgeInsets.fromLTRB(12, 16, 0, 0),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => setState(() => selectedDDLocation = value),
        selectedItem: selectedDDLocation,
        maxHeight: MediaQuery.of(context).size.height * .7,
      ),
    );
  }

  Widget colorizeButton() {
    Color _color = HexColor.fromHex('#303a52');
    return Container(
      padding: const EdgeInsets.only(right: 15),
      child: FlatButton.icon(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Colors.transparent,
        hoverColor: Colors.transparent,
        onPressed: () => setNextMapper(),
        icon: Icon(Icons.palette, size: 30, color: _color),
        label: Text('$shapeColorMapper cases', style: TextStyle(fontSize: 20, color: _color)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MySfMap(selectedDDLocation, shapeColorMapper),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getCountryDropdown(),
              colorizeButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class MySfMap extends StatefulWidget {
  const MySfMap(this.selectedDDLocation, this.shapeColorMapper);
  final String selectedDDLocation;
  final String shapeColorMapper;
  @override
  _MySfMapState createState() => _MySfMapState();
}

class _MySfMapState extends State<MySfMap> {
  MapShapeLayerDelegate _mapShapeDelegate;
  List<CovidTotalDataModel> _covidTotalData;
  final MapZoomPanBehavior _zoomPanBehavior = MapZoomPanBehavior(
    enablePinching: true, // TODO: errors on scrolling
    maxZoomLevel: 7,
    // ZoomToolBar
    toolbarSettings: MapToolbarSettings(
      direction: Axis.vertical,
      position: MapToolbarPosition.bottomRight,
      // itemBackgroundColor: Colors.red,
    ),
  );
  String selectedMapLocation;
  MapShapeLayerController mapController = MapShapeLayerController();
  DateTime today = DateTime.now().toLocal();

  Future<bool> asyncInit() async {
    _covidTotalData = await getTotalData(widget.selectedDDLocation);

    _mapShapeDelegate = MapShapeLayerDelegate(
      shapeFile: 'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: _covidTotalData.length,
      primaryValueMapper: (int index) => _covidTotalData[index].countryName,
      shapeColorValueMapper: (int index) => _covidTotalData[index].params[widget.shapeColorMapper], //
      shapeColorMappers: myColorMappers[widget.shapeColorMapper], //
      shapeTooltipTextMapper: (int index) {
        return 'Country : ' +
            _covidTotalData[index].countryName +
            '\nActive: ' +
            formatNumber(_covidTotalData[index].active) +
            '\nRecovered: ' +
            formatNumber(_covidTotalData[index].recovered) +
            '\nDeaths: ' +
            formatNumber(_covidTotalData[index].deaths) +
            '\nTotal: ' +
            formatNumber(_covidTotalData[index].total);
      },
    );
    return true;
  }

  void showParamsBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => myBottomSheet(index),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.grey.withOpacity(.5),
    ).then((value) => mapController.selectedIndex = -1);
  }

  Widget myBottomSheet(int index) {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
          color: HexColor.fromHex('#efecec').withOpacity(.8),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          right: 15,
          left: 15,
          bottom: (MediaQuery.of(context).viewInsets.bottom == 0) ? 15 : MediaQuery.of(context).viewInsets.bottom + 5,
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(selectedMapLocation, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
                  Text(DateFormat('yyyy-MM-dd').format(today), style: TextStyle(fontSize: 20)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total: ' + formatNumber(_covidTotalData[index].total), style: TextStyle(fontSize: 20)),
                      Text('Active: ' + formatNumber(_covidTotalData[index].active), style: TextStyle(fontSize: 20)),
                      Text('Recovered: ' + formatNumber(_covidTotalData[index].recovered), style: TextStyle(fontSize: 20)),
                      Text('Deaths: ' + formatNumber(_covidTotalData[index].deaths), style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Text('Some graphs here with prediction', style: TextStyle(fontSize: 20)),
                  CircularProgressIndicator(),
                ],
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) return Center(child: CircularProgressIndicator());
        return GestureDetector(
          onTap: () {
            var index = mapController.selectedIndex;
            if (index != -1) {
              selectedMapLocation = _covidTotalData[index].countryName;
              showParamsBottomSheet(index);
            }
          },
          child: SfMaps(
            layers: <MapShapeLayer>[
              MapShapeLayer(
                delegate: _mapShapeDelegate,
                enableSelection: true,
                controller: mapController,
                legendSource: MapElement.shape,
                legendSettings: MapLegendSettings(
                  position: MapLegendPosition.bottom,
                  textStyle: TextStyle(fontSize: 15, color: Colors.black),
                  iconSize: Size(15, 15),
                  iconType: MapIconType.circle,
                ),
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
        );
      },
    );
  }
}
