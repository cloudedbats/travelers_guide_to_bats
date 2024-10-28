import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelers_guide_to_bats/src/data/model/model.dart' as model;

part 'countries_state.dart';

enum Status { initial, loading, success, failure }

class CountriesResultData {
  Status status = Status.initial;
  String filterString = '';
  List<model.Country> filteredCountries = [];

  CountriesResultData({
    this.status = Status.initial,
    this.filterString = '',
    this.filteredCountries = const [],
  });
}

class CountriesCubit extends Cubit<CountriesState> {
  CountriesCubit() : super(CountriesState(CountriesResultData()));

  Future<void> setInitialCountry() async {
    // Load stored value.
    final filterString = await _loadCountryFilterString();
    // Tell consumers that we are working.
    CountriesResultData result = CountriesResultData();
    result.status = Status.loading;
    result.filterString = filterString;
    emit(CountriesState(result));
    // Filtering based in stored value.
    await filterCountryByString(filterString);
  }

  Future<void> filterCountryByString(String filterString) async {
    // Filtering based on filterString.
    late List<model.Country> filteredCountries;
    filteredCountries = model.filterCountriesByString(filterString);
    // Create result.
    CountriesResultData result = CountriesResultData();
    result.status = Status.success;
    result.filterString = filterString;
    result.filteredCountries = filteredCountries;
    // Inform consumers.
    emit(CountriesState(result));
    // Keep filterString for next app start.
    _saveCountryFilterString(filterString);
  }

  Future<void> _saveCountryFilterString(String filterString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filterString', filterString);
  }

  Future<String> _loadCountryFilterString() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('filterString') ?? '';
  }
}
