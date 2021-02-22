import 'package:bank_todo/data/models/weather_model.dart';

class StartLoadingWeatherAction {
  StartLoadingWeatherAction(this.apiKey, this.lat, this.lon);

  final String apiKey;
  final double lat;
  final double lon;
}

class WeatherSuccessAction {
  final WeatherModel current;

  WeatherSuccessAction(this.current);
}

class WeatherFailedAction {
  WeatherFailedAction();
}
