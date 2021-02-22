import 'package:bank_todo/redux/user/user_actions.dart';
import 'package:bank_todo/redux/user/user_state.dart';
import 'package:redux/redux.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, LoginSuccessAction>(_loginSuccess),
  TypedReducer<UserState, LoginFailedAction>(_loginFailed),
  TypedReducer<UserState, StartLoadingAction>(_startLoading),
  TypedReducer<UserState, UpdateUserInfo>(_updateSuccess),
  TypedReducer<UserState, LogoutUserAction>(_logoutUser),
]);

UserState _loginSuccess(UserState state, LoginSuccessAction action) {
  return state.copyWith(user: action.user, isLoading: false, loginError: false);
}

UserState _updateSuccess(UserState state, UpdateUserInfo action) {
  return state.copyWith(user: action.user, isLoading: false, loginError: false);
}

UserState _loginFailed(UserState state, LoginFailedAction action) {
  return state.copyWith(user: null, isLoading: false, loginError: true);
}

UserState _logoutUser(UserState state, LogoutUserAction action) {
  return state.copyWith(user: null, isLoading: false, loginError: false);
}

UserState _startLoading(UserState state, StartLoadingAction action) {
  return state.copyWith(isLoading: true, loginError: false);
}
