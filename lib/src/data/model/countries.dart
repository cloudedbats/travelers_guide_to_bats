// Runtime data storage.
List<Country> countries = [];
Map<String, String> countryNameByCountryCode = {};
Map<String, List> taxaByCountryCode = {};

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

void addTaxonToCountry(String taxonId, String countryCode) {
  // Add object to lookup map.
  if (!taxaByCountryCode.containsKey(countryCode)) {
    taxaByCountryCode[countryCode] = [];
  }
  taxaByCountryCode[countryCode]!.add(taxonId);
}

void clearAll() {
  countries.clear();
  countryNameByCountryCode.clear();
  taxaByCountryCode.clear();
}

void sortCountries() {
  countries.sort((a, b) => a.countryName.compareTo(b.countryName));
}

List<Country> filterCountriesByString(String filterString) {
  List<Country> filteredList = countries
      .where((a) =>
          a.countryName.toLowerCase().contains(filterString.toLowerCase()) ||
          a.countryCode.toLowerCase().contains(filterString.toLowerCase())
          )
      .toList();
  return filteredList;
}
