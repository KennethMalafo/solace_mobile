import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:solace_mobile_frontend/screens/user_disaster_reports.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'notification_page.dart';
import 'package:solace_mobile_frontend/screens/ligtas_tips_screen.dart';
import 'package:solace_mobile_frontend/screens/evacuation_location.dart';
import 'package:solace_mobile_frontend/weather_and_disaster_forecasting/weather_api.dart';
import 'package:solace_mobile_frontend/weather_and_disaster_forecasting/weather_model.dart';
import 'package:solace_mobile_frontend/weather_and_disaster_forecasting/notification_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;  // This holds the index of the current tab

  // This function will handle the tab change
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;  // Change the current index
    });
  }

  // Method to switch directly to the Evacuation location tab
  void _goToEvacuationLocation() {
    setState(() {
      _currentIndex = 2;  // Switch to the Evacuation location tab (index 2)
    });
  }

  // Dynamically generate the screens list
  List<Widget> get _screens {
    return [
      HomeContent(onShowEvacuationLocation: _goToEvacuationLocation), // Pass the callback here
      const LigtasTips(),
      const EvacuationLocation(),
      const ImageUploadScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom < 34 ? 8 : 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WaterDropNavBar(
                waterDropColor: Colors.blue[900]!,
                onItemSelected: _onItemTapped,
                selectedIndex: _currentIndex,
                bottomPadding: bottomPadding,
                barItems: [
                  BarItem(
                    filledIcon: Icons.home,
                    outlinedIcon: Icons.home_outlined,
                  ),
                  BarItem(
                    filledIcon: Icons.tips_and_updates,
                    outlinedIcon: Icons.tips_and_updates_outlined,
                  ),
                  BarItem(
                    filledIcon: Icons.map,
                    outlinedIcon: Icons.map_outlined,
                  ),
                  BarItem(
                    filledIcon: Icons.add_a_photo,
                    outlinedIcon: Icons.add_a_photo_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final VoidCallback onShowEvacuationLocation;
  const HomeContent({super.key, required this.onShowEvacuationLocation});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  Future<WeatherData>? weatherData;
  Future<double>? waterLevelData; // Change this to Future<double> to hold the water level
  bool isRefreshing = false;
  late AnimationController _animationController;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  List<ConnectivityResult> _connectivityResult = [];

  @override
  void initState() {
    super.initState();
    weatherData = fetchWeather();
    waterLevelData = fetchWaterLevel(); // Fetch the water level initially
    // Initial connectivity check
    _checkInitialConnectivity();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Subscribe to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result; // Update the connectivity state
      });

       // Check if we have internet connection from the result
      if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        // Refetch the weather data when connectivity changes
        setState(() {
          weatherData = fetchWeather(); // Refresh weather data
          waterLevelData = fetchWaterLevel();
        });
      }
    });
  }

      // Check if we have internet connection from the result
      //if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        //_refreshWeatherandWaterLevel();
     // }
   // });
  //}

  Future<void> _checkInitialConnectivity() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    setState(() {}); // Update UI based on initial connectivity status
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _connectivitySubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _refreshWeatherandWaterLevel() async {
  setState(() {
    isRefreshing = true; // Set refreshing to true when the pull-down occurs
  });

  try {
    // Attempt to fetch new weather and water level data
    weatherData = fetchWeather();
    waterLevelData = fetchWaterLevel();
  } catch (e) {
    // Show an error message or handle the error if fetching fails
    if (kDebugMode) {
      print("Failed to refresh data: $e");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to refresh data. Please check your connection.")),
    );
  } finally {
    // Reset refreshing state after attempt to fetch
    setState(() {
      isRefreshing = false;
    });
  }
}

  Future<double> fetchWaterLevel() async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection('water_level')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var latestDocument = snapshot.docs.first;
      var data = latestDocument.data();
      double currentWaterLevel = data['waterlevel']?.toDouble() ?? 0.0;
      //currentWaterLevel; // Add 4 to the fetched water level
      return currentWaterLevel;
    }
    return 0.0;
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching water level data: $e");
    }
    throw Exception("Failed to fetch water level due to a connection issue.");
  }
}

  Stream<double> waterLevelStream() {
    return FirebaseFirestore.instance
        .collection('water_level')
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            var latestDocument = snapshot.docs.first;
            var data = latestDocument.data();
            double currentWaterLevel = data['waterlevel']?.toDouble() ?? 0.0;
            return currentWaterLevel; //+ 4.0; // Add 4 to the fetched water level
          }
          return 0.0;
        });
  }

  @override
  Widget build(BuildContext context) {
    NotificationHandler().initNotification(context); 
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent, // Make the AppBar transparent
      elevation: 0,  // Remove shadow
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Sol",
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              color: Colors.blue[900],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.07,
              maxHeight: screenHeight * 0.1,
            ),
            child: Image.asset(
              'images/a_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          Text(
            'ce RiverWatch',
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              color: Colors.blue[900],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(title: "No Title", body: "No new notifications"),
                ),
              );
            },
          ),
      ],
    ),
  backgroundColor: Colors.blue[100],
  body: _connectivityResult.isEmpty || _connectivityResult.contains(ConnectivityResult.none)
          ? const Center(
              child: Text(
                'Please turn on your internet',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            )

    // If internet is available, proceed with the content
    : CustomRefreshIndicator(
      onRefresh: _refreshWeatherandWaterLevel,
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            if (controller.isDragging || controller.value > 0)
              Positioned(
                top: 20 * controller.value,
                child: Opacity(
                  opacity: controller.value.clamp(0.0, 1.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Circular loading indicator if refreshing
                        if (isRefreshing)
                          const CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        // Water drop icon always visible
                        Opacity(
                          opacity: isRefreshing ? 0.5 : 1.0, // Slightly transparent when loading
                          child: const Icon(
                            Icons.water_drop,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Transform.translate(
              offset: Offset(0, 70 * controller.value),
              child: child,
            ),
          ],
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather Data Section (FutureBuilder)
            FutureBuilder<WeatherData>(
              future: weatherData,
              builder: (context, snapshot) {
                // Handle errors when fetching data
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading message or placeholder while waiting for data
                  return const Center(child: Text('Fetching weather data, Please wait...'));
                } else if (snapshot.hasData) {
                  try {
                    final data = snapshot.data!;
                    return Column(
                      children: [
                        WeatherBox(
                          date: DateTime.now().toLocal().toString().split(' ')[0],
                          temperature: data.current.temperature,
                          condition: data.current.condition,
                          location: data.location,
                          iconUrl: data.current.iconUrl,
                        ),
                        const SizedBox(height: 20),
                        HourlyForecast(hourlyWeather: data.hourly),
                      ],
                    );
                  } catch (e) {
                    // Handle any errors that may happen while accessing data
                    return Center(
                      child: Text('Error processing weather data. Please check your internet connection: $e'),
                    );
                  }
                } else {
                  // Fallback if no data is available
                  return const Center(child: Text('No weather data available.'));
                }
              },
            ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Status',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontFamily: 'Inter',
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        StreamBuilder<double>(
                          stream: waterLevelStream(), // Use the Future<double> here
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(child: Text('Error fetching water level'));
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('Fetching water level, Please wait...'));
                            }

                            final currentLevel = snapshot.data!;
                            bool isAlert = currentLevel >= 6.20 && currentLevel < 7.00;
                            bool isCritical = currentLevel >= 7.00;

                            return Column(
                              children: [
                                DigitalWaterGauge(
                                  currentLevel: currentLevel,
                                  maxLevel: 9.0,
                                ),
                                if (isAlert || isCritical) const SizedBox(height: 20),
                                if (isAlert || isCritical)
                                  Column(
                                    children: [
                                      Text(
                                        isAlert
                                            ? 'Alert Water Level Reached!'
                                            : 'Critical: High Water Level!',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          color: isAlert ? Colors.orange : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isAlert
                                                  ? [Colors.orange, Colors.orange[300]!]
                                                  : [Colors.redAccent, Colors.red[300]!], // Apply gradient based on the status
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: widget.onShowEvacuationLocation,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent, // Make background transparent to show the gradient
                                              shadowColor: Colors.transparent,
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                            ),
                                            child: const Text(
                                              "View Evacuation Routes",
                                              style: TextStyle(color: Colors.white), 
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.02),
                          child: Text(
                            'Legends:',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w800,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        Legends(color: Colors.green, text: 'Normal \n6.19 MASL', fontSize: screenWidth * 0.03),
                        Legends(color: Colors.yellow, text: 'Alert \n6.99 MASL', fontSize: screenWidth * 0.03),
                        Legends(color: Colors.red, text: 'Critical \n7.00 MASL', fontSize: screenWidth * 0.03),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherBox extends StatelessWidget {
  final String date;
  final int temperature;
  final String condition;
  final String location;
  final String iconUrl;

  const WeatherBox({
    super.key,
    required this.date,
    required this.temperature,
    required this.condition,
    required this.location,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.blue[300]!, Colors.blue[500]!], // Gradient background
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Weather Condition (Largest Font)
                Text(
                  condition,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // Biggest font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // Location (Third Largest Font) aligned with condition
                Text(
                  location,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, // Third largest font size
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                // Current Date (Smallest Font)
                Text(
                  date,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // Smallest font size
                    color: Colors.black54,
                  ),
                ),
                // Temperature (Second Largest Font)
                Text(
                  '$temperature°C',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05, // Second biggest font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Image.network(
              iconUrl,
              fit: BoxFit.contain, // Ensure the image fits within the container
            ),
          ),
        ],
      ),
    );
  }
}

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> hourlyWeather;

  const HourlyForecast({super.key, required this.hourlyWeather});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Forecast',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,  // Set a fixed height for the forecast
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyWeather.length,
            itemBuilder: (context, index) {
              final weather = hourlyWeather[index];
              return Container(
                width: screenWidth * 0.20, // Each box's width
                margin: const EdgeInsets.only(right: 10), // Space between boxes
                padding: const EdgeInsets.all(10),  // Padding inside each box
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[100]!, Colors.blue[300]!, Colors.blue[500]!], // Gradient background
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display hour only (remove date)
                    Text(
                      weather.time.split(' ')[1].substring(0, 5), 
                      style: TextStyle(
                        fontSize: screenWidth * 0.028,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Weather icon
                    Image.network(
                      weather.iconUrl,
                      width: screenWidth * 0.07,
                      height: screenWidth * 0.07,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 5),
                    // Temperature in °C
                    Text(
                      '${weather.temperature}°C',
                      style: TextStyle(
                        fontSize: screenWidth * 0.028,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Ruler extends StatelessWidget {
  final double maxHeight;
  final double currentLevel;

  const Ruler({
    super.key,
    required this.maxHeight,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    final rulerHeight = maxHeight * 20; // Example scaling for visual representation

    return CustomPaint(
      size: Size(40, rulerHeight), // Width for the ruler
      painter: RulerPainter(maxHeight: maxHeight, currentLevel: currentLevel),
    );
  }
}

class RulerPainter extends CustomPainter {
  final double maxHeight;
  final double currentLevel;

  RulerPainter({required this.maxHeight, required this.currentLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Draw the labels for each meter
    for (int i = 0; i <= maxHeight.toInt(); i++) {
      final y = size.height - (i / maxHeight * size.height);
      // Draw the meter labels
      TextPainter tp = TextPainter(
        text: TextSpan(
          text: '${i.toDouble().toStringAsFixed(1)} m',
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      // Position the text a bit more to the right for visibility
      tp.paint(canvas, Offset(4, y - tp.height / 2)); // Adjust x position
    }

    // Draw only the line for the current water level
    final currentY = size.height - (currentLevel / maxHeight * size.height);
    paint.color = Colors.blue; // Color for the current water level line
    canvas.drawLine(Offset(0, currentY), Offset(size.width, currentY), paint); // Water level line
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DigitalWaterGauge extends StatefulWidget {
  final double currentLevel;
  final double maxLevel;

  const DigitalWaterGauge({
    super.key,
    required this.currentLevel,
    required this.maxLevel,
  });

  @override
  DigitalWaterGaugeState createState() => DigitalWaterGaugeState();
}

class DigitalWaterGaugeState extends State<DigitalWaterGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showStatusDialog() {
    String statusText = _getStatusText(widget.currentLevel);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Current Status'),
          content: Text(statusText),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to determine the water status based on the current level
  String _getStatusText(double level) {
    if (level < 6.2) {
      return 'Normal Level: The water level is stable.';
    } else if (level < 7.0) {
      return 'Alert Level: Water level is slightly elevated.';
    } else {
      return 'Critical Level: Water level is dangerously high!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final gaugeWidth = screenWidth * 0.59;  // Responsive gauge width
    final gaugeHeight = screenHeight * 0.3;  // Responsive gauge height

    return Row(
      children: [
        // Ruler on the left
        SizedBox(
          width: 40, // Fixed width for the ruler
          height: gaugeHeight, // Match height of the gauge
          child: Ruler(
            maxHeight: 9.0, // Maximum height in meters
            currentLevel: widget.currentLevel, // Current water level
          ),
        ),
        const SizedBox(width: 10), // Space between ruler and gauge
        // Water gauge
        Expanded(
          child: GestureDetector(
            onTap: _showStatusDialog, // Show status dialog on tap
            child: CustomPaint(
              size: Size(gaugeWidth, gaugeHeight),
              painter: WavePainter(
                currentLevel: widget.currentLevel,
                maxLevel: widget.maxLevel,
                animation: _controller,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final double currentLevel;
  final double maxLevel;
  final Animation<double> animation;

  WavePainter({
    required this.currentLevel,
    required this.maxLevel,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // If the water level is 0, skip the wave drawing
    if (currentLevel == 0) {
      // Just draw the status text and icon without the wave
      _drawStatusTextAndIcon(canvas, size);
      return; // Early exit to avoid drawing the wave
    }

    final double waveHeight = (currentLevel / maxLevel) * size.height;

    // Gradient color based on current level
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: _getGradientColors(currentLevel),
    );

    // Define a rect to paint the gradient
    final rect = Rect.fromLTWH(0, size.height - waveHeight, size.width, size.height);

    Paint waterPaint = Paint()
      ..shader = gradient.createShader(rect);

    Path wavePath = Path();

    // Keep wave frequency constant
    double waveFrequency = size.width / 1;

    // Calculate wave speed based on the current level
    double waveSpeed = _getWaveSpeed(currentLevel);

    // Create the wave path
    for (double x = 0; x <= size.width; x++) {
      double y = _getWaveAmplitude(currentLevel) * sin((x / waveFrequency * 2 * pi) + (animation.value * waveSpeed * 2 * pi));
      wavePath.lineTo(x, size.height - waveHeight + y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, waterPaint);

    // Draw the status text and icon (still drawn even if currentLevel is 0)
    _drawStatusTextAndIcon(canvas, size);
  }

  // Draw the status text and corresponding icon
  void _drawStatusTextAndIcon(Canvas canvas, Size size) {
    String statusText = _getStatusText(currentLevel);
    IconData statusIcon = _getStatusIcon(currentLevel); // Get corresponding icon
    
    // TextPainter for status text
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: statusText,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(canvas, Offset(10, size.height - 50));

    // Draw the icon beside the text
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(statusIcon.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: statusIcon.fontFamily,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    iconPainter.layout();
    iconPainter.paint(canvas, Offset(10 + textPainter.width + 5, size.height - 50));
  }

  // Function to determine the water status based on the current level
  String _getStatusText(double level) {
    if (level < 6.2) {
      return 'Normal Level';
    } else if (level < 7.0) {
      return 'Alert Level';
    } else {
      return 'Critical Level';
    }
  }

  // Get the icon based on water level
  IconData _getStatusIcon(double level) {
    if (level < 6.2) {
      return Icons.check_circle; // Icon for normal
    } else if (level < 7.0) {
      return Icons.warning; // Icon for alert
    } else {
      return Icons.dangerous; // Icon for critical
    }
  }

  // Function to get dynamic wave amplitude based on the current level
  double _getWaveAmplitude(double level) {
    if (level < 6.2) {
      return 10; // Amplitude for normal level
    } else if (level < 7.0) {
      return 11; // Amplitude for alert level
    } else {
      return 12; // Amplitude for critical level
    }
  }

  // Function to get gradient colors based on the current level
  List<Color> _getGradientColors(double level) {
    if (level < 6.2) {
      return [Colors.greenAccent, Colors.green[300]!]; // Gradient for normal level
    } else if (level < 7.0) {
      return [Colors.yellowAccent, Colors.yellow[300]!]; // Gradient for alert level
    } else {
      return [Colors.redAccent, Colors.red[300]!]; // Gradient for critical level
    }
  }

  // Function to get wave speed based on the current level
  double _getWaveSpeed(double level) {
    if (level < 6.2) {
      return 2.0; // Slow wave speed for normal level
    } else if (level < 7.0) {
      return 3.0; // Medium speed for alert level
    } else {
      return 4.0; // Fast speed for critical level
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Legends extends StatelessWidget {
  final Color color;
  final String text;
  final double fontSize;

  const Legends({
    super.key,
    required this.color,
    required this.text,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5), // Shadow effect
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}