import 'package:bank_todo/redux/app_state.dart';
import 'package:bank_todo/redux/user/user_reducer.dart';

AppState appReducer(AppState state, action) {
  print(action);
  return AppState(
    userState: userReducer(state.userState, action),

  );
}
