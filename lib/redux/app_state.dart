import 'package:bank_todo/redux/user/user_state.dart';
import 'package:bank_todo/redux/weather/weather_state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final UserState userState;
  final WeatherState weatherState;

  AppState({@required this.userState, @required this.weatherState});

  factory AppState.initial() {
    return AppState(
        userState: UserState.initial(), weatherState: WeatherState.initial());
  }

  AppState copyWith({
    userState,
    weatherState,
  }) {
    return AppState(
      userState: userState ?? this.userState,
      weatherState: weatherState ?? this.weatherState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          userState == other.userState &&
          weatherState == other.weatherState;

  @override
  int get hashCode => userState.hashCode;

  @override
  String toString() {
    return 'AppState{'
        '\nuserState: '
        '\n$userState}'
        '\nweatherState: '
        '\n$weatherState}';
  }
}
