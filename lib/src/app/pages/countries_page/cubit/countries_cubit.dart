import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelers_guide_to_bats/src/data/model/model.dart' as model;

part 'countries_state.dart';

enum CountriesStatus { initial, loading, success, failure }

class CountriesResult {
  CountriesStatus status = CountriesStatus.initial;
  String? filterString;
  List<model.Country> filteredCountries = [];
  String message = '';

  CountriesResult({
    this.status = CountriesStatus.initial,
    this.filterString,
    this.filteredCountries = const [],
    this.message = '',
  });
}

class CountriesCubit extends Cubit<CountriesState> {
  CountriesCubit() : super(CountriesState(CountriesResult()));

  String? lastUsedFilterString;

  Future<void> loadInitialCountry() async {
    // Load stored value.
    final filterString = await _loadCountryFilterString();
    lastUsedFilterString = filterString;
  }

  Future<void> filterCountryByString(String filterString) async {
    // Keep filterString for next app start.
    lastUsedFilterString = filterString;
    _saveCountryFilterString(filterString);
    // Inform consumers.
    late CountriesResult result;
    result = CountriesResult();
    result.status = CountriesStatus.loading;
    emit(CountriesState(result));
    // Filtering based on filterString.
    try {
      late List<model.Country> filteredCountries;
      filteredCountries = await model.filterCountriesByString(filterString);
      // Inform consumers.
      result = CountriesResult();
      result.status = CountriesStatus.success;
      result.filterString = filterString;
      result.filteredCountries = filteredCountries;
      emit(CountriesState(result));
    } on Exception catch (e) {
      // Inform consumers.
      result = CountriesResult();
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

  String? lastUsedFilter() {
    return lastUsedFilterString == '' ? null : lastUsedFilterString;
  }
}
