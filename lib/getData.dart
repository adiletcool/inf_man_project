import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _url = "covid-19-data.p.rapidapi.com";
const Map<String, String> _headers = {
  "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
  "x-rapidapi-key": "96c9bf6347mshaa70842b22ac472p17ea96jsncd83f482d9aa",
  "useQueryString": 'true',
};
Future<void> getDateByCountry(String name) async {
  var query = {
    "format": "json",
    "name": name,
  };
  var uri = Uri.https(_url, '/country', query);
  var response = await http.get(uri, headers: _headers);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    print(jsonResponse);
  } else {
    print(response.body);
    print('Request failed with status: ${response.statusCode}.');
  }
}
