import 'package:bank_todo/data/models/user_model.dart';
import 'package:meta/meta.dart';

@immutable
class UserState {
  final bool isLoading;
  final bool loginError;
  final UserModel user;

  UserState({
    @required this.isLoading,
    @required this.loginError,
    @required this.user,
  });

  factory UserState.initial() {
    return new UserState(isLoading: false, loginError: false, user: null);
  }

  UserState copyWith({bool isLoading, bool loginError, UserModel user}) {
    return new UserState(
        isLoading: isLoading ?? this.isLoading,
        loginError: loginError ?? this.loginError,
        user: user);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          loginError == other.loginError &&
          user == other.user;

  @override
  int get hashCode => isLoading.hashCode ^ user.hashCode;
}
