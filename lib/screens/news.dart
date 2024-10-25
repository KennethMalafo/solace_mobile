import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String latitude = '15.9774';
const String longitude = '120.4242';
const String apiKey = '1257c323501fde9df99b778ff7b50408';
const double rainfallToWaterLevelRatio = 0.03533;

Future<Map<String, dynamic>> fetchLatestWaterLevel() async {
  try {
    // Replace this with the Firestore call to get the latest water level
    final snapshot = await FirebaseFirestore.instance
        .collection("water_level")
        .orderBy("date", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final latestDocument = snapshot.docs.first;
      final data = latestDocument.data();
      // Ensure 'waterlevel' exists and is not null, or use 0 as a fallback
      final waterLevel = (data['waterlevel'] ?? 0) + 4;
      // Correct date handling: Use toDate() if it's a Firestore Timestamp
      final date = (data['date'] as Timestamp).toDate(); 

      return {
        'waterLevel': waterLevel,
        'date': date,
      };
    } else {
      if (kDebugMode) {
        print("No water level data found.");
      }
      return {};
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error fetching latest water level: $error');
    }
    return {};
  }
}

Future<void> updateWaterLevels(BuildContext context) async {
  final latestWaterLevelData = await fetchLatestWaterLevel();
  if (latestWaterLevelData.isEmpty) {
    if (kDebugMode) {
      print('No latest water level data available.');
    }
    return;
  }

  double currentWaterLevel = (latestWaterLevelData['waterLevel'] as num).toDouble();

  List<double> futureWaterLevels = [];
  List<String> labels = [];

  const String weatherApiUrl =
      'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey';
  final response = await http.get(Uri.parse(weatherApiUrl));
  final weatherData = json.decode(response.body);

  for (var i = 0; i < weatherData['list'].length; i++) {
    final forecast = weatherData['list'][i];
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
    final String localTime = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

    double futureWaterLevel = currentWaterLevel;
    String weatherCondition = forecast['weather'][0]['main'].toLowerCase();

    if (weatherCondition.contains('clear')) {
      futureWaterLevel -= 0.05;
    } else if (weatherCondition.contains('mist')) {
      futureWaterLevel -= 0.01;
    } else if (weatherCondition.contains('rain')) {
      double rainfall = (forecast['rain'] != null && forecast['rain']['3h'] != null)
    ? (forecast['rain']['3h'] as num).toDouble()
    : 0.0;
      if (rainfall > 0 && rainfall <= 5) {
        futureWaterLevel += rainfall * rainfallToWaterLevelRatio;
      } else if (rainfall > 5) {
        futureWaterLevel += rainfall * rainfallToWaterLevelRatio * 1.5;
      }
    }

    futureWaterLevel = double.parse(futureWaterLevel.toStringAsFixed(2));
    if (i == 1) {
      updateWaterLevelUI(context, futureWaterLevel);
    }

    futureWaterLevels.add(futureWaterLevel);
    labels.add(localTime);
  }

  // Optionally limit data for the chart
  List<String> limitedLabels = labels.take(6).toList();
  List<double> limitedFutureWaterLevels = futureWaterLevels.take(6).toList();
  
  updateChartUI(limitedLabels, limitedFutureWaterLevels);
}

void updateWaterLevelUI(BuildContext context, double futureWaterLevel) {
  final waterLevelText = '$futureWaterLevel MASL';
  final color = (futureWaterLevel <= 6)
      ? Colors.green
      : (futureWaterLevel > 6 && futureWaterLevel <= 6.2)
          ? Colors.blue
          : Colors.orange;

  // Update your UI with new water level
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(waterLevelText), backgroundColor: color),
  );
}

void updateChartUI(List<String> labels, List<double> waterLevels) {
  // This function should update your Flutter chart widget with new data
  // Here, you would pass the data to the chart widget, such as using a package like fl_chart or charts_flutter
  // For example:
  if (kDebugMode) {
    print('Labels: $labels');
  }
  if (kDebugMode) {
    print('Water Levels: $waterLevels');
  }
}

// Usage in Flutter widget
class WaterLevelPredictionWidget extends StatelessWidget {
  const WaterLevelPredictionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Level Prediction'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => updateWaterLevels(context),
          child: const Text('Get Future Water Levels'),
        ),
      ),
    );
  }
}
