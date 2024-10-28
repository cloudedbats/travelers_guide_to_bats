// import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

import 'package:travelers_guide_to_bats/src/data/model/model.dart' as model;

Future<void> loadData() async {
  // Load excel file from assets.
  ByteData data =
      await rootBundle.load('assets/files/redlist_chiroptera_2021-1.xlsx');
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);
  // Loop over Excel sheets.
  // for (var table in excel.tables.keys) {
  //   print('Excel sheet: $table');
  // }

  // Help function.
  String cellValueToString(element) =>
      element == null ? "" : element.value.toString();

  excel.tables.forEach((sheetName, sheet) {
    if (sheetName == 'Countries') {
      for (var row in sheet.rows) {
        if (row.elementAt(0)!.rowIndex == 0) {
          continue;
        }
        String countryCode = cellValueToString(row.elementAt(0));
        String countryName = cellValueToString(row.elementAt(1));
        model.addCountry(countryCode, countryName);
      }
    }
    if (sheetName == 'Chiroptera by country') {
      for (var row in sheet.rows) {
        if (row.elementAt(0)!.rowIndex == 0) {
          continue;
        }
        String countryCode = cellValueToString(row.elementAt(0));
        String taxonId = cellValueToString(row.elementAt(1));
        model.addTaxonToCountry(countryCode, taxonId);
      }
    }
    if (sheetName == 'Chiroptera info') {
      for (var row in sheet.rows) {
        if (row.elementAt(0)!.rowIndex == 0) {
          continue;
        }
        String scientificName = cellValueToString(row.elementAt(0));
        String taxonId = cellValueToString(row.elementAt(1));
        String taxonKingdom = cellValueToString(row.elementAt(2));
        String taxonPhylum = cellValueToString(row.elementAt(3));
        String taxonClass = cellValueToString(row.elementAt(4));
        String taxonOrder = cellValueToString(row.elementAt(5));
        String taxonFamily = cellValueToString(row.elementAt(6));
        String taxonGenus = cellValueToString(row.elementAt(7));
        String commonName = cellValueToString(row.elementAt(8));
        String authority = cellValueToString(row.elementAt(9));
        String publishedYear = cellValueToString(row.elementAt(10));
        String redListCategory = cellValueToString(row.elementAt(11));

        model.addTaxonInfo(
            scientificName,
            taxonId,
            taxonKingdom,
            taxonPhylum,
            taxonClass,
            taxonOrder,
            taxonFamily,
            taxonGenus,
            commonName,
            authority,
            publishedYear,
            redListCategory);
      }
    }
  });

  model.sortCountries();
  model.sortTaxaInfo();

  // print('countries.length: ${model.countries.length}');
  // print('countryNameByCountryCode.length: ${model.countryNameByCountryCode.length}');
  // print('taxaByCountryCode.length: ${model.taxaByCountryCode.length}');
  // print('taxaInfo.length: ${model.taxaInfo.length}');
  // print('infoById.length: ${model.infoById.length}');
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
