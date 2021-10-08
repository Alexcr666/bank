import 'package:bank_todo/data/networking/api.dart';
import 'package:bank_todo/redux/app_reducer.dart';
import 'package:bank_todo/redux/app_state.dart';
import 'package:bank_todo/redux/user/user_middleware.dart';

import 'package:redux/redux.dart';

class Redux {
  static Store<AppState> _store;

  static API api = API();

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    _store = Store<AppState>(appReducer,
        initialState: new AppState.initial(),
        middleware: [LoginMiddleware(api)]);
  }
}
