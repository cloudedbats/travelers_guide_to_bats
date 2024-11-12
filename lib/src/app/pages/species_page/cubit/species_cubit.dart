import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelers_guide_to_bats/src/data/model/model.dart' as model;

part 'species_state.dart';

enum Status { initial, loading, success, failure }

class SpeciesResultData {
  Status status = Status.initial;
  String filterString = '';
  List<model.TaxonInfo> filteredSpecies = [];

  SpeciesResultData({
    this.status = Status.initial,
    this.filterString = '',
    this.filteredSpecies = const [],
  });
}

class SpeciesCubit extends Cubit<SpeciesState> {
  SpeciesCubit() : super(SpeciesState(SpeciesResultData()));

  static String? lastUsedFilterString;

  Future<void> setInitialSpecies() async {
    // Load stored value.
    final filterString = await _loadSpeciesFilterString();
    lastUsedFilterString = filterString;
    // String filterString = '';
    // Tell consumers that we are working.
    SpeciesResultData result = SpeciesResultData();
    result.status = Status.loading;
    result.filterString = filterString;
    emit(SpeciesState(result));
    // Filtering based in stored value.
    await filterSpeciesByString(filterString);
  }

  Future<void> filterSpeciesByString(String filterString) async {
    // Filtering based on filterString.
    late List<model.TaxonInfo> filteredSpecies;
    filteredSpecies = model.filterSpeciesByCountryCode(filterString);
    // Create result.
    SpeciesResultData result = SpeciesResultData();
    result.status = Status.success;
    result.filterString = filterString;
    result.filteredSpecies = filteredSpecies;
    // Inform consumers.
    emit(SpeciesState(result));
    // Keep filterString for next app start.
    _saveSpeciesFilterString(filterString);
  }

  Future<void> _saveSpeciesFilterString(String filterString) async {
    lastUsedFilterString = filterString;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filterString', filterString);
  }

  Future<String> _loadSpeciesFilterString() async {
    final prefs = await SharedPreferences.getInstance();
    String filterString = prefs.getString('filterString') ?? '';
    return filterString;
  }

  static String? getLastUsedFilterString() {
    return lastUsedFilterString  == '' ? null : lastUsedFilterString;
  }
}
