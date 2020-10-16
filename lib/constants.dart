import 'package:syncfusion_flutter_maps/maps.dart' show MapColorMapper;
import 'HexColor.dart';
import 'package:intl/intl.dart';

var formatter = NumberFormat('###,000');
String formatNumber(int number) {
  return number > 1000 ? formatter.format(number) : number.toString();
}

Map<String, List<MapColorMapper>> myColorMappers = {
  'Active': [
    MapColorMapper(from: 0, to: 9999, color: HexColor.fromHex('#ffd460')),
    MapColorMapper(from: 10000, to: 99999, color: HexColor.fromHex('#f07b3f')),
    MapColorMapper(from: 100000, to: 499999, color: HexColor.fromHex('#ea5455')),
    MapColorMapper(from: 500000, to: 999999, color: HexColor.fromHex('#973961')),
    MapColorMapper(from: 1000000, to: 1499999, color: HexColor.fromHex('#623448')),
    MapColorMapper(from: 1500000, to: 1999999, color: HexColor.fromHex('#36162e')),
    MapColorMapper(from: 2000000, to: 3000000, color: HexColor.fromHex('#200f21')),
  ],
  'Total': [
    MapColorMapper(from: 0, to: 49999, color: HexColor.fromHex('#ffd460')),
    MapColorMapper(from: 50000, to: 99999, color: HexColor.fromHex('#f07b3f')),
    MapColorMapper(from: 100000, to: 299999, color: HexColor.fromHex('#ea5455')),
    MapColorMapper(from: 300000, to: 599999, color: HexColor.fromHex('#973961')),
    MapColorMapper(from: 600000, to: 1299999, color: HexColor.fromHex('#623448')),
    MapColorMapper(from: 1300000, to: 1999999, color: HexColor.fromHex('#36162e')),
    MapColorMapper(from: 2000000, to: 4000000, color: HexColor.fromHex('#200f21')),
    MapColorMapper(from: 4000000, to: 20000000, color: HexColor.fromHex('160F21')),
  ],
  'Recovered': [
    MapColorMapper(from: 0, to: 9999, color: HexColor.fromHex('#ffd460')),
    MapColorMapper(from: 10000, to: 99999, color: HexColor.fromHex('#f07b3f')),
    MapColorMapper(from: 100000, to: 499999, color: HexColor.fromHex('#ea5455')),
    MapColorMapper(from: 500000, to: 999999, color: HexColor.fromHex('#973961')),
    MapColorMapper(from: 1000000, to: 1499999, color: HexColor.fromHex('#623448')),
    MapColorMapper(from: 1500000, to: 1999999, color: HexColor.fromHex('#36162e')),
    MapColorMapper(from: 2000000, to: 2999999, color: HexColor.fromHex('#200f21')),
    MapColorMapper(from: 3000000, to: 200000000, color: HexColor.fromHex('160F21')),
  ],
  'Deaths': [
    MapColorMapper(from: 0, to: 99, color: HexColor.fromHex('#ffd460')),
    MapColorMapper(from: 100, to: 999, color: HexColor.fromHex('#f07b3f')),
    MapColorMapper(from: 1000, to: 4999, color: HexColor.fromHex('#ea5455')),
    MapColorMapper(from: 5000, to: 9999, color: HexColor.fromHex('#973961')),
    MapColorMapper(from: 10000, to: 29999, color: HexColor.fromHex('#623448')),
    MapColorMapper(from: 30000, to: 69999, color: HexColor.fromHex('#36162e')),
    MapColorMapper(from: 70000, to: 179999, color: HexColor.fromHex('#200f21')),
    MapColorMapper(from: 180000, to: 3000000, color: HexColor.fromHex('#200f21')),
  ],
};

List<String> countriesList = <String>[
  'World',
  'Afghanistan',
  'Albania',
  'Algeria',
  'Andorra',
  'Angola',
  'Anguilla',
  'Antigua-and-Barbuda',
  'Argentina',
  'Armenia',
  'Aruba',
  'Australia',
  'Austria',
  'Azerbaijan',
  'Bahamas',
  'Bahrain',
  'Bangladesh',
  'Barbados',
  'Belarus',
  'Belgium',
  'Belize',
  'Benin',
  'Bermuda',
  'Bhutan',
  'Bolivia',
  'Bosnia-and-Herzegovina',
  'Botswana',
  'Brazil',
  'British-Virgin-Islands',
  'Brunei',
  'Bulgaria',
  'Burkina-Faso',
  'Burundi',
  'Cabo-Verde',
  'Cambodia',
  'Cameroon',
  'Canada',
  'CAR',
  'Caribbean-Netherlands',
  'Cayman-Islands',
  'Chad',
  'Channel-Islands',
  'Chile',
  'China',
  'Colombia',
  'Comoros',
  'Congo',
  'Costa-Rica',
  'Croatia',
  'Cuba',
  'Cura&ccedil;ao',
  'Cyprus',
  'Czechia',
  'Denmark',
  'Diamond-Princess',
  'Diamond-Princess-',
  'Djibouti',
  'Dominica',
  'Dominican-Republic',
  'DRC',
  'Ecuador',
  'Egypt',
  'El-Salvador',
  'Equatorial-Guinea',
  'Eritrea',
  'Estonia',
  'Eswatini',
  'Ethiopia',
  'Faeroe-Islands',
  'Falkland-Islands',
  'Fiji',
  'Finland',
  'France',
  'French-Guiana',
  'French-Polynesia',
  'Gabon',
  'Gambia',
  'Georgia',
  'Germany',
  'Ghana',
  'Gibraltar',
  'Greece',
  'Greenland',
  'Grenada',
  'Guadeloupe',
  'Guam',
  'Guatemala',
  'Guinea',
  'Guinea-Bissau',
  'Guyana',
  'Haiti',
  'Honduras',
  'Hong-Kong',
  'Hungary',
  'Iceland',
  'India',
  'Indonesia',
  'Iran',
  'Iraq',
  'Ireland',
  'Isle-of-Man',
  'Israel',
  'Italy',
  'Ivory-Coast',
  'Jamaica',
  'Japan',
  'Jordan',
  'Kazakhstan',
  'Kenya',
  'Kuwait',
  'Kyrgyzstan',
  'Laos',
  'Latvia',
  'Lebanon',
  'Lesotho',
  'Liberia',
  'Libya',
  'Liechtenstein',
  'Lithuania',
  'Luxembourg',
  'Macao',
  'Madagascar',
  'Malawi',
  'Malaysia',
  'Maldives',
  'Mali',
  'Malta',
  'Martinique',
  'Mauritania',
  'Mauritius',
  'Mayotte',
  'Mexico',
  'Moldova',
  'Monaco',
  'Mongolia',
  'Montenegro',
  'Montserrat',
  'Morocco',
  'Mozambique',
  'MS-Zaandam',
  'MS-Zaandam-',
  'Myanmar',
  'Namibia',
  'Nepal',
  'Netherlands',
  'New-Caledonia',
  'New-Zealand',
  'Nicaragua',
  'Niger',
  'Nigeria',
  'North-Macedonia',
  'Norway',
  'Oman',
  'Pakistan',
  'Palestine',
  'Panama',
  'Papua-New-Guinea',
  'Paraguay',
  'Peru',
  'Philippines',
  'Poland',
  'Portugal',
  'Puerto-Rico',
  'Qatar',
  'R&eacute;union',
  'Romania',
  'Russia',
  'Rwanda',
  'S-Korea',
  'Saint-Kitts-and-Nevis',
  'Saint-Lucia',
  'Saint-Martin',
  'Saint-Pierre-Miquelon',
  'San-Marino',
  'Sao-Tome-and-Principe',
  'Saudi-Arabia',
  'Senegal',
  'Serbia',
  'Seychelles',
  'Sierra-Leone',
  'Singapore',
  'Sint-Maarten',
  'Slovakia',
  'Slovenia',
  'Solomon-Islands',
  'Somalia',
  'South-Africa',
  'South-Sudan',
  'Spain',
  'Sri-Lanka',
  'St-Barth',
  'St-Vincent-Grenadines',
  'Sudan',
  'Suriname',
  'Sweden',
  'Switzerland',
  'Syria',
  'Taiwan',
  'Tajikistan',
  'Tanzania',
  'Thailand',
  'Timor-Leste',
  'Togo',
  'Trinidad-and-Tobago',
  'Tunisia',
  'Turkey',
  'Turks-and-Caicos',
  'UAE',
  'Uganda',
  'UK',
  'Ukraine',
  'Uruguay',
  'US-Virgin-Islands',
  'USA',
  'Uzbekistan',
  'Vatican-City',
  'Venezuela',
  'Vietnam',
  'Western-Sahara',
  'Yemen',
  'Zambia',
  'Zimbabwe',
];
