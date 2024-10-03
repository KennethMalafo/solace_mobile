import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:solace_mobile_frontend/screens/ligtas_tips_screen.dart';
import 'package:solace_mobile_frontend/screens/notifications_screen.dart';
import 'package:solace_mobile_frontend/weather_forecasting/weather_api.dart';
import 'package:solace_mobile_frontend/weather_forecasting/weather_model.dart';

class HomeScreenTest extends StatefulWidget {
  const HomeScreenTest({super.key});

  @override
  HomeScreenTestState createState() => HomeScreenTestState();
}

class HomeScreenTestState extends State<HomeScreenTest> {
  int _currentIndex = 0;  // This holds the index of the current tab

  // Screens for each tab in BottomNavigationBar
  final List<Widget> _screens = [
    const HomeContent(),
    const LigtasTips(),
    const NotificationsScreen(),
  ];

  // This function will handle the tab change
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;  // Change the current index
    });
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
                    filledIcon: Icons.notifications,
                    outlinedIcon: Icons.notifications_none,
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
  const HomeContent({super.key});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  bool hasInternet = false; // Track internet connectivity

  @override
  void initState() {
    super.initState();
    _checkConnectivity(); // Initial connectivity check

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      _checkConnectivity(); // Check connectivity whenever it changes
    });
  }

Future<void> _checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  print("Connectivity result: $connectivityResult");

  // Assume initially not connected
  bool isConnected = false;

  // Check if connected to mobile data or Wi-Fi
  if (connectivityResult == ConnectivityResult.mobile || 
      connectivityResult == ConnectivityResult.wifi) {
    // Now let's perform a real check for internet availability
    isConnected = await checkInternetConnection();
  }

  print("Is connected to a network: $isConnected");

  setState(() {
    hasInternet = isConnected;
  });
}
Future<bool> checkInternetConnection() async {
  try {
    final response = await http.get(Uri.parse('https://www.google.com'));
    print("Response status code: ${response.statusCode}"); // Log the response status
    return response.statusCode == 200; // Check if we received a successful response
  } catch (e) {
    print("Error checking internet connection: $e");
    return false; // Return false if any error occurs
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: hasInternet ? _buildContent() : _buildNoInternetMessage(),
    );
  }

  Widget _buildNoInternetMessage() {
    return Center(
      child: Text("Please turn on your internet."),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Text("You are online!"),
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
    if (level <= 6.0) {
      return 'Normal Level: The water level is stable.';
    } else if (level <= 6.2) {
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

    // Draw the status text and icon
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
    if (level <= 6.0) {
      return 'Normal Level';
    } else if (level <= 6.2) {
      return 'Alert Level';
    } else {
      return 'Critical Level';
    }
  }

  // Get the icon based on water level
  IconData _getStatusIcon(double level) {
    if (level <= 6.0) {
      return Icons.check_circle; // Icon for normal
    } else if (level <= 6.2) {
      return Icons.warning; // Icon for alert
    } else {
      return Icons.dangerous; // Icon for critical
    }
  }

  // Function to get dynamic wave amplitude based on the current level
  double _getWaveAmplitude(double level) {
    if (level <= 6.0) {
      return 10; // Amplitude for normal level
    } else if (level <= 6.2) {
      return 15; // Amplitude for alert level
    } else {
      return 20; // Amplitude for critical level
    }
  }

  // Function to get gradient colors based on the current level
  List<Color> _getGradientColors(double level) {
    if (level <= 6.0) {
      return [Colors.greenAccent, Colors.green[300]!]; // Gradient for normal level
    } else if (level <= 6.2) {
      return [Colors.yellowAccent, Colors.yellow[300]!]; // Gradient for alert level
    } else {
      return [Colors.redAccent, Colors.red[300]!]; // Gradient for critical level
    }
  }

  // Function to get wave speed based on the current level
  double _getWaveSpeed(double level) {
    if (level <= 6.0) {
      return 3.0; // Slow wave speed for normal level
    } else if (level <= 6.2) {
      return 5.0; // Medium speed for alert level
    } else {
      return 7.0; // Fast speed for critical level
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
