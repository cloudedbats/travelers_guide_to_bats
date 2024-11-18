// Runtime data storage.
List<Country> countries = [];
Map<String, String> countryNameByCountryCode = {};
Map<String, List> taxaByCountryCode = {};
Map<String, List> countriesByTaxonId = {};

// Class definitions and methods.
class Country {
  String countryCode;
  String countryName;

  Country({
    required this.countryCode,
    required this.countryName,
  });
}

void addCountry(String countryCode, String countryName) {
  // Add object to list.
  countries.add(Country(countryCode: countryCode, countryName: countryName));
  // Add object to lookup map.
  countryNameByCountryCode[countryCode] = countryName;
}

void addTaxonToCountry(String countryCode, String taxonId) {
  // Create lookup map.
  if (!taxaByCountryCode.containsKey(countryCode)) {
    taxaByCountryCode[countryCode] = [];
  }
  taxaByCountryCode[countryCode]!.add(taxonId);
  // Create lookup map.
  if (!countriesByTaxonId.containsKey(taxonId)) {
    countriesByTaxonId[taxonId] = [];
  }
  countriesByTaxonId[taxonId]!.add(countryCode);
}

void clearAll() {
  countries.clear();
  countryNameByCountryCode.clear();
  taxaByCountryCode.clear();
}

void sortCountries() {
  countries.sort((a, b) => a.countryName.compareTo(b.countryName));
}

Future<List<Country>> filterCountriesByString(String filterString) async {
  List<Country> filteredList = countries
      .where((a) =>
          a.countryName.toLowerCase().contains(filterString.toLowerCase()) ||
          a.countryCode.toLowerCase().contains(filterString.toLowerCase()))
      .toList();
  return filteredList;
}
