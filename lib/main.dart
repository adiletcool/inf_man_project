import 'package:flutter/material.dart';
import 'package:inf_man_project/HexColor.dart';
import 'package:inf_man_project/constants.dart';
import 'package:inf_man_project/dataModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'getData.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

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
  MapShapeLayerDelegate _mapShapeDelegate;
  List<CovidTotalDataModel> _covidTotalData;
  List<MapColorMapper> _colorMappers;
  MapZoomPanBehavior _zoomPanBehavior;

  Future<void> test(name) async {
    await getDateByCountry(name);
  }

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior(maxZoomLevel: 7);
    _covidTotalData = getTotalData();

    _colorMappers = [
      MapColorMapper(from: 0, to: 99999, color: Color.fromRGBO(3, 192, 150, 1), text: 'Less than \$1'),
      MapColorMapper(from: 100000, to: 299999, color: Color.fromRGBO(3, 192, 150, 0.6), text: '\$1 - \$4.99'),
      MapColorMapper(from: 300000, to: 499999, color: Color.fromRGBO(3, 192, 150, 0.35), text: '\$5 - \$9.99'),
      MapColorMapper(from: 500000, to: 799999, color: Color.fromRGBO(255, 175, 33, 1.0), text: '\$10 - \$29.99'),
      MapColorMapper(from: 800000, to: 999999, color: Color.fromRGBO(255, 175, 33, 0.70), text: '\$30 - \$49.99'),
      MapColorMapper(from: 1000000, to: 10000000, color: Color.fromRGBO(255, 175, 33, 0.40), text: '\$50 and More'),
    ];

    _mapShapeDelegate = MapShapeLayerDelegate(
      shapeFile: 'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: _covidTotalData.length,
      primaryValueMapper: (int index) => _covidTotalData[index].countryName,
      shapeTooltipTextMapper: (int index) {
        return 'State : ' + (_covidTotalData[index].countryName) + '\nActive : \$' + _covidTotalData[index].active.toString();
      },
      shapeColorValueMapper: (int index) => _covidTotalData[index].active,
      shapeColorMappers: _colorMappers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor.fromHex('#4b89ac'),
        title: Text('COVID-19', style: TextStyle(fontSize: 25)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      CountryDropdown(),
                      SizedBox(height: 20),
                      MySfSlider(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: MySfChart(),
                  ),
                ),
              ],
            ),
          ),
          // Divider(thickness: 1),
          Flexible(
            flex: 1,
            child: MySfMap(_mapShapeDelegate, _zoomPanBehavior),
          )
        ],
      ),
    );
  }
}

class MySfSlider extends StatefulWidget {
  @override
  _MySfSliderState createState() => _MySfSliderState();
}

class _MySfSliderState extends State<MySfSlider> {
  List<SliderData> _chartData;
  final DateTime dateMin = DateTime(2019, 12, 31);
  final DateTime dateMax = DateTime(2020, 10, 13);
  SfRangeValues dateValues;
  List<List<dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    dateValues = SfRangeValues(dateMin, dateMax);
    _chartData = List.generate(worldCases.length, (i) {
      return SliderData(x: DateTime.parse(worldCases[i][0]), y: worldCases[i][1]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SfRangeSelector(
        min: dateMin,
        max: dateMax,
        initialValues: dateValues,
        interval: 1,
        dateIntervalType: DateIntervalType.years,
        dateFormat: DateFormat.yMd(),
        showTooltip: true,
        child: Container(
          height: 200,
          child: SfCartesianChart(
            margin: const EdgeInsets.all(0),
            primaryXAxis: DateTimeAxis(
              minimum: dateMin,
              maximum: dateMax,
              isVisible: true,
            ),
            primaryYAxis: NumericAxis(isVisible: false, maximum: 400000),
            series: <SplineAreaSeries<SliderData, DateTime>>[
              SplineAreaSeries<SliderData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (SliderData sales, _) => sales.x,
                yValueMapper: (SliderData sales, _) => sales.y,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CountryDropdown extends StatefulWidget {
  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class MySfChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <LineSeries<SalesData, String>>[
        LineSeries<SalesData, String>(
            dataSource: <SalesData>[
              SalesData('Jan', 35),
              SalesData('Feb', 28),
              SalesData('Mar', 34),
              SalesData('Apr', 32),
              SalesData('May', 40),
            ],
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
            dataLabelSettings: DataLabelSettings(isVisible: true)),
      ],
    );
  }
}

class MySfMap extends StatelessWidget {
  const MySfMap(this._mapShapeDelegate, this._zoomPanBehavior);

  final MapShapeLayerDelegate _mapShapeDelegate;
  final MapZoomPanBehavior _zoomPanBehavior;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SfMaps(
        layers: <MapShapeLayer>[
          MapShapeLayer(
            delegate: _mapShapeDelegate,
            enableShapeTooltip: true,
            zoomPanBehavior: _zoomPanBehavior,
          )
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class SliderData {
  SliderData({this.x, this.y});

  final DateTime x;
  final double y;
}
