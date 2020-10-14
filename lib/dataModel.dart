import 'dart:convert';

import 'package:http/http.dart' as http;

class CovidTotalDataModel {
  const CovidTotalDataModel(this.countryName, this.active, {this.total, this.recovered, this.deaths});
  final String countryName;
  final int active;
  final int total;
  final int recovered;
  final int deaths;
}

Future<http.Response> getStats() async {
  var headers = {
    'x-rapidapi-host': "covid-193.p.rapidapi.com",
    'x-rapidapi-key': "96c9bf6347mshaa70842b22ac472p17ea96jsncd83f482d9aa",
  };
  var response = await http.get('https://rapidapi.p.rapidapi.com/statistics', headers: headers);
  return response;
}

var replacedName = {
  'UK': 'United Kingdom',
  'USA': 'United States of America',
  'Czechia': 'Czech Rep.',
  'UAE': 'United Arab Emirates',
  'Saudi-Arabia': 'Saudi Arabia',
  'South-Africa': 'South Africa',
  'CAR': 'Central African Rep.',
  'DRC': 'Dem. Rep. Congo',
  'South-Sudan': 'S. Sudan',
  'Equatorial-Guinea': 'Eq. Guinea',
  'Burkina-Faso': 'Burkina Faso',
  'Ivory-Coast': "Côte d'Ivoire",
  'Western-Sahara': 'W. Sahara',
  'Sierra-Leone': 'Sierra Leone',
  'S-Korea': 'Korea',
  'Laos': 'Lao PDR',
  'Sri-Lanka': 'Sri Lanka',
  'Papua-New-Guinea': 'Papua New Guinea',
  'Solomon-Islands': 'Solomon Is.',
  'New-Caledonia': 'New Caledonia',
  'New-Zealand': 'New Zealand',
  'Bosnia-and-Herzegovina': 'Bosnia and Herz.',
  'North-Macedonia': 'Macedonia',
  'Falkland-Islands': 'Falkland Is.',
  'El-Salvador': 'El Salvador',
  'Costa-Rica': 'Costa Rica',
  'Dominican-Republic': 'Dominican Rep.',
  'Puerto-Rico': 'Puerto Rico'
};

Future<List<CovidTotalDataModel>> getTotalData() async {
  var resp = await getStats();
  List decoded = jsonDecode(resp.body)['response'];

  return List.generate(decoded.length, (i) {
    var country = decoded[i]['country'];
    country = replacedName.keys.contains(country) ? replacedName[country] : country;
    return CovidTotalDataModel(
      country,
      decoded[i]['cases']['active'],
      total: decoded[i]['cases']['total'],
      recovered: decoded[i]['cases']['recovered'],
      deaths: decoded[i]['deaths']['total'],
    );
  });
}
