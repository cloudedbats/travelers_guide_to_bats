import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/model/model.dart' as model;

part 'by_country_state.dart';

enum ByCountryStatus { initial, loading, success, failure }

class ByCountryResult {
  ByCountryStatus status = ByCountryStatus.initial;
  String? filterString;
  List<model.TaxonInfo> filteredByCountry = [];
  String message = '';

  ByCountryResult({
    this.status = ByCountryStatus.initial,
    this.filterString,
    this.filteredByCountry = const [],
    this.message = '',
  });
}

class ByCountryCubit extends Cubit<ByCountryState> {
  ByCountryCubit() : super(ByCountryState(ByCountryResult()));

  String? lastUsedFilterString;

  Future<void> loadInitialByCountry() async {
    // Load stored value.
    final filterString = await _loadByCountryFilterString();
    lastUsedFilterString = filterString;
  }

  Future<void> filterByCountryByString(String filterString) async {
    // Keep filterString for next app start.
    lastUsedFilterString = filterString;
    _saveByCountryFilterString(filterString);
    // Start filtering.
    late ByCountryResult result;
    // Inform consumers.
    result = ByCountryResult();
    result.status = ByCountryStatus.loading;
    emit(ByCountryState(result));
    // Filtering based on filterString.
    try {
      late List<model.TaxonInfo> filteredByCountry;
      filteredByCountry = await model.filterByCountryCode(filterString);
      // Inform consumers.
      result = ByCountryResult();
      result.status = ByCountryStatus.success;
      result.filterString = filterString;
      result.filteredByCountry = filteredByCountry;
      emit(ByCountryState(result));
    } on Exception catch (e) {
      // Inform consumers.
      result = ByCountryResult();
      result.status = ByCountryStatus.failure;
      result.message = e.toString();
      emit(ByCountryState(result));
    }
  }

  Future<void> _saveByCountryFilterString(String filterString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('byCountryFilter', filterString);
  }

  Future<String> _loadByCountryFilterString() async {
    final prefs = await SharedPreferences.getInstance();
    String filterString = prefs.getString('byCountryFilter') ?? '';
    return filterString;
  }

  String? lastUsedFilter() {
    return lastUsedFilterString == '' ? null : lastUsedFilterString;
  }
}
