import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'getting_location.dart';
import 'weather_model.dart';

Future<WeatherData> fetchWeather() async {
  Position position = await getCurrentLocation();
  if (kDebugMode) {
    print('Current Location: Latitude ${position.latitude}, Longitude ${position.longitude}');
  }

  // Fetch current weather
  final currentResponse = await http.get(Uri.parse(
    'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=1257c323501fde9df99b778ff7b50408',
  ));

  if (kDebugMode) {
    print('Current Weather Response Status: ${currentResponse.statusCode}');
  }

  // Fetch hourly forecast
  final hourlyResponse = await http.get(Uri.parse(
    'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=1257c323501fde9df99b778ff7b50408',
  ));

  if (kDebugMode) {
    print('Hourly Forecast Response Status: ${hourlyResponse.statusCode}');
  }

  if (currentResponse.statusCode == 200 && hourlyResponse.statusCode == 200) {
    final currentWeatherJson = json.decode(currentResponse.body);
    final hourlyWeatherJson = json.decode(hourlyResponse.body);

    if (kDebugMode) {
      print('Current Weather JSON: $currentWeatherJson');
    }
    if (kDebugMode) {
      print('Hourly Weather JSON: $hourlyWeatherJson');
    }

    CurrentWeather current = CurrentWeather(
      temperature: (currentWeatherJson['main']['temp'] - 273.15).round(), // Convert from Kelvin to Celsius
      condition: currentWeatherJson['weather'][0]['description'],
      iconUrl: 'http://openweathermap.org/img/wn/${currentWeatherJson['weather'][0]['icon']}@2x.png',
    );

    List<HourlyWeather> hourly = (hourlyWeatherJson['list'] as List).map((hour) {
      return HourlyWeather(
        temperature: (hour['main']['temp'] - 273.15).round(),
        iconUrl: 'http://openweathermap.org/img/wn/${hour['weather'][0]['icon']}@2x.png',
        time: hour['dt_txt'],
      );
    }).toList();

    // Get the current time
    DateTime now = DateTime.now();
    if (kDebugMode) {
      print('Current Local Time: $now');
    }

    // Create a list to hold the next four hours
    List<HourlyWeather> nextFourHours = [];

    // Iterate through the hourly list and find the next four hours
    for (var hour in hourly) {
      DateTime hourTime = DateTime.parse(hour.time);
      if (kDebugMode) {
        print('UTC Time: ${hourTime.toUtc()} | Local Time: $hourTime');
      }

      if (hourTime.isAfter(now) && nextFourHours.length < 4) {
        nextFourHours.add(hour);
        if (kDebugMode) {
          print('Added Hour: ${hour.temperature}°C at ${hour.time}');
        }
      }
    }

    return WeatherData(
      current: current,
      location: "${currentWeatherJson['name']}, ${currentWeatherJson['sys']['country']}",
      hourly: nextFourHours,
    );
  } else {
    if (kDebugMode) {
      print('Failed to load weather data');
    }
    throw Exception('Failed to load weather data');
  }
}
