import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/model/model.dart' as model;

part 'bats_state.dart';

enum BatsStatus { initial, loading, success, failure }

class BatsResult {
  BatsStatus status = BatsStatus.initial;
  String? filterString;
  List<model.TaxonInfo> filteredBats = [];
  String message = '';

  BatsResult({
    this.status = BatsStatus.initial,
    this.filterString,
    this.filteredBats = const [],
    this.message = '',
  });
}

class BatsCubit extends Cubit<BatsState> {
  BatsCubit() : super(BatsState(BatsResult()));

  String? lastUsedFilterString;

  Future<void> loadInitialBats() async {
    // Load stored value.
    final filterString = await _loadBatsFilterString();
    lastUsedFilterString = filterString;
  }

  Future<void> filterBatsByString(String filterString) async {
    // Keep filterString for next app start.
    lastUsedFilterString = filterString;
    _saveBatsFilterString(filterString);
    // Inform consumers.
    late BatsResult result;
    result = BatsResult();
    result.status = BatsStatus.loading;
    emit(BatsState(result));
    // Filtering based on filterString.
    try {
      late List<model.TaxonInfo> filteredBats;
      filteredBats = await model.filterBatsByString(filterString);
      // Inform consumers.
      result = BatsResult();
      result.status = BatsStatus.success;
      result.filterString = filterString;
      result.filteredBats = filteredBats;
      emit(BatsState(result));
    } on Exception catch (e) {
      // Inform consumers.
      result = BatsResult();
      result.status = BatsStatus.failure;
      result.message = e.toString();
      emit(BatsState(result));
    }
  }

  Future<void> _saveBatsFilterString(String filterString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('batsFilter', filterString);
  }

  Future<String> _loadBatsFilterString() async {
    final prefs = await SharedPreferences.getInstance();
    String filterString = prefs.getString('batsFilter') ?? '';
    return filterString;
  }

  String? lastUsedFilter() {
    return lastUsedFilterString == '' ? null : lastUsedFilterString;
  }
}
