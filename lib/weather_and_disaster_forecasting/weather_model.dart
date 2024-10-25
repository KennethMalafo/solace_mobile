class WeatherData {
  final CurrentWeather current;
  final String location;
  final List<HourlyWeather> hourly;

  WeatherData({
    required this.current,
    required this.location,
    required this.hourly,
  });
}

class CurrentWeather {
  final int temperature;
  final String condition;
  final String iconUrl;

  CurrentWeather({
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });
}

class HourlyWeather {
  final int temperature;
  final String iconUrl;
  final String time;

  HourlyWeather({
    required this.temperature,
    required this.iconUrl,
    required this.time,
  });
}
