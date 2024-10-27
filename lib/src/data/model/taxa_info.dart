// Runtime data storage.
List<TaxonInfo> taxaInfo = List.empty(growable: true);
Map<String, TaxonInfo> infoById = {};

// Class definitions and methods.
class TaxonInfo {
  String scientificName; // 0
  String taxonId; // 1
  String taxonKingdom; // 2
  String taxonPhylum; // 3
  String taxonClass; // 4
  String taxonOrder; // 5
  String taxonFamily; // 6
  String taxonGenus; // 7
  String commonName; // 8
  String authority; // 9
  String publishedYear; // 10
  String redListCategory; // 11

  TaxonInfo({
    required this.scientificName,
    required this.taxonId,
    required this.taxonKingdom,
    required this.taxonPhylum,
    required this.taxonClass,
    required this.taxonOrder,
    required this.taxonFamily,
    required this.taxonGenus,
    required this.commonName,
    required this.authority,
    required this.publishedYear,
    required this.redListCategory,
  });
}

void addTaxonInfo(
  String scientificName,
  String taxonId,
  String taxonKingdom,
  String taxonPhylum,
  String taxonClass,
  String taxonOrder,
  String taxonFamily,
  String taxonGenus,
  String commonName,
  String authority,
  String publishedYear,
  String redListCategory,
) {
  // Create object.
  TaxonInfo taxonInfo = TaxonInfo(
    scientificName: scientificName,
    taxonId: taxonId,
    taxonKingdom: taxonKingdom,
    taxonPhylum: taxonPhylum,
    taxonClass: taxonClass,
    taxonOrder: taxonOrder,
    taxonFamily: taxonFamily,
    taxonGenus: taxonGenus,
    commonName: commonName,
    authority: authority,
    publishedYear: publishedYear,
    redListCategory: redListCategory,
  );
  // Add object to list.
  taxaInfo.add(taxonInfo);
  // Add object to lookup map.
  infoById[taxonId] = taxonInfo;
}

void clearTaxonInfoList() {
  taxaInfo.clear();
}

void sortTaxaInfo() {
  return taxaInfo.sort((a, b ) => a.scientificName.compareTo(b.scientificName));
}

// scientific_name 0
// taxonid 1
// kingdom 2
// phylum 3
// class 4
// order 5
// family 6
// genus 7
// main_common_name 8
// authority 9
// published_year 10
// category 11

// NOT USED:
// criteria 12
// marine_system 13
// freshwater_system 14
// terrestrial_system 15
// aoo_km2 eoo_km2 16
// elevation_upper 17
// elevation_lower 18
// depth_upper 19
// depth_lower 20
// assessor 21
// reviewer 22
// errata_flag 23
// errata_reason 24
// amended_flag 25
// amended_reason 26