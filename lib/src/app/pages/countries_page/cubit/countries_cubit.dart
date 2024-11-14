import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelers_guide_to_bats/src/data/model/model.dart' as model;

part 'countries_state.dart';

enum CountriesStatus { initial, loading, success, failure }

class CountriesResultData {
  CountriesStatus status = CountriesStatus.initial;
  String filterString = '';
  List<model.Country> filteredCountries = [];
  String message = '';

  CountriesResultData({
    this.status = CountriesStatus.initial,
    this.filterString = '',
    this.filteredCountries = const [],
    this.message = '',
  });
}

class CountriesCubit extends Cubit<CountriesState> {
  CountriesCubit() : super(CountriesState(CountriesResultData()));

  static String? lastUsedFilterString;

  Future<void> loadInitialCountry() async {
    // Load stored value.
    final filterString = await _loadCountryFilterString();
    lastUsedFilterString = filterString;

    // filterCountryByString(filterString);
    // // Inform consumers.
    // CountriesResultData result = CountriesResultData();
    // result.status = CountriesStatus.success;
    // emit(CountriesState(result));
  }

  Future<void> filterCountryByString(String filterString) async {
    lastUsedFilterString = filterString;
    // Inform consumers.
    CountriesResultData result = CountriesResultData();
    result.status = CountriesStatus.loading;
    emit(CountriesState(result));
    // Filtering based on filterString.
    try {
      late List<model.Country> filteredCountries;
      filteredCountries = model.filterCountriesByString(filterString);
      // Inform consumers.
      result.status = CountriesStatus.success;
      result.filterString = filterString;
      result.filteredCountries = filteredCountries;
      emit(CountriesState(result));
      // Keep filterString for next app start.
      _saveCountryFilterString(filterString);
    } on Exception catch (e) {
      // Inform consumers.
      result = CountriesResultData();
      result.status = CountriesStatus.failure;
      result.message = e.toString();
      emit(CountriesState(result));
    }
  }

  Future<void> _saveCountryFilterString(String filterString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('countryFilter', filterString);
  }

  Future<String> _loadCountryFilterString() async {
    final prefs = await SharedPreferences.getInstance();
    String filterString = prefs.getString('countryFilter') ?? '';
    return filterString;
  }

  static String? getLastUsedFilterString() {
    return lastUsedFilterString == '' ? null : lastUsedFilterString;
  }
}
