import 'package:bank_todo/redux/user/user_state.dart';

import 'package:meta/meta.dart';

@immutable
class AppState {
  final UserState userState;


  AppState({@required this.userState});

  factory AppState.initial() {
    return AppState(
        userState: UserState.initial());
  }

  AppState copyWith({
    userState,
    weatherState,
  }) {
    return AppState(
      userState: userState ?? this.userState,

    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          userState == other.userState ;


  @override
  int get hashCode => userState.hashCode;

  @override
  String toString() {
    return 'AppState{'
        '\nuserState: '
        '\n$userState}'
        ;
  }
}
