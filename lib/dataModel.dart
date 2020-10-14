class CovidTotalDataModel {
  const CovidTotalDataModel(this.countryName, this.active, {this.covfirmed, this.recovered, this.deaths});
  final String countryName;
  final int active;
  final int covfirmed;
  final int recovered;
  final int deaths;
}

List<CovidTotalDataModel> getTotalData() {
  return <CovidTotalDataModel>[
    CovidTotalDataModel('Russia', 500000),
    CovidTotalDataModel('United States of America', 200000),
  ];
}
