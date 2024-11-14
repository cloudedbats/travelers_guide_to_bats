import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/load_data.dart' as core;

part 'data_state.dart';

enum DataStatus { initial, loading, success, failure }

class DataResultData {
  DataStatus status = DataStatus.initial;

  DataResultData({
    this.status = DataStatus.initial,
  });
}

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataState(DataResultData()));

  static String lastException = '';

  Future<void> loadData() async {
    lastException = '';
    // Tell consumers that we are working.
    late DataResultData result;
    result = DataResultData();
    result.status = DataStatus.loading;
    emit(DataState(result));
    // Load data from assets to model.
    try {
      await core.loadData();
    } on Exception catch (e) {
      lastException = e.toString();
      result.status = DataStatus.failure;
      emit(DataState(result));
      return;
    }
    // Tell consumers that we are done.
    result = DataResultData();
    result.status = DataStatus.success;
    emit(DataState(result));
  }

  static String getLastException() {
    return lastException;
  }
}
