import '../data/model/model.dart' as model;

String getSpeciesByCountryAsHtml(String countryName, String countryCode) {
  List<dynamic>? taxa = model.taxaByCountryCode[countryCode];

  List<model.TaxonInfo> taxaInfo = [];
  for (String taxonId in taxa ?? []) {
    model.TaxonInfo? info = model.infoById[taxonId];
    if (info != null) {
      taxaInfo.add(info);
    }
  }

  taxaInfo.sort((a, b) {
    String first = a.taxonFamily + a.scientificName;
    String second = b.taxonFamily + b.scientificName;
    return first.compareTo(second);
  });

  String resultString = '';
  resultString += '<h2>';
  resultString += countryName;
  resultString += '</h2>';
  resultString += 'Number of bat species: ';
  resultString += '<strong>';
  resultString += taxaInfo.length.toString();
  resultString += '</strong>';
  resultString += '<br><br>';
  String oldFamily = '';
  for (model.TaxonInfo taxon in taxaInfo) {
    if (taxon.taxonFamily != oldFamily) {
      resultString += 'Family: ';
      resultString += '<i><strong>';
      resultString += taxon.taxonFamily;
      resultString += '</strong></i>';
      resultString += '<br><br>';
      oldFamily = taxon.taxonFamily;
    }
    resultString += '    ';
    resultString += '<i><strong>&emsp;&emsp;';
    resultString += taxon.scientificName;
    resultString += '</strong></i>';
    resultString += ' - ';
    resultString += taxon.commonName;
    resultString += ' - ';
    resultString += taxon.redListCategory;
    resultString += '<br><br>';
  }
  return resultString;
}

String getCountriesBySpeciesAsHtml(
  String scientificName,
  String commonName,
  String taxonId,
) {
  List<dynamic>? countries = model.countriesByTaxonId[taxonId];
  List<String> countryNameList = [];
  for (String countryCode in countries ?? []) {
    String? countryName = model.countryNameByCountryCode[countryCode];
    if (countryName != null) {
      countryNameList.add('$countryName   ($countryCode)');
    }
  }
  countryNameList.sort((a, b) {
    return a.compareTo(b);
  });

  String resultString = '';
  resultString += '<h2>';
  resultString += '<i>';
  resultString += scientificName;
  resultString += '</i>';
  resultString += ' - ';
  resultString += commonName;
  resultString += '</h2>';
  resultString += 'Distribution: ';
  resultString += '<br><br>';
  for (String countryName in countryNameList) {
    resultString += '<strong>';
    resultString += countryName;
    resultString += '</strong>';
    resultString += '<br>';
  }
  return resultString;
}
