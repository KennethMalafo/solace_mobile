import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:solace_mobile_frontend/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      _controller.reverse().then((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  double textSize = mediaQuery.size.width * 0.07;
  double imageHeight = mediaQuery.size.height * 0.1;
  double imageWidth = mediaQuery.size.width * 0.07;
  double progressBarWidth = mediaQuery.size.width * 0.6;
  double progressBarHeight = 20.0;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(animation: _controller),
                child: Container(),
              );
            },
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: mediaQuery.size.height, // Ensure it takes at least the height of the screen
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                    children: <Widget>[
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Sol', style: TextStyle(fontSize: textSize, fontFamily: 'Inter', color: Colors.blue[900])),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: imageWidth,
                                    maxHeight: imageHeight,
                                  ),
                                  child: Image.asset(
                                    'images/a_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text('ce', style: TextStyle(fontSize: textSize, fontFamily: 'Inter', color: Colors.blue[900])),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Water Level Monitoring',
                              style: TextStyle(fontSize: textSize, fontFamily: 'Inter', color: Colors.blue[900]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.02),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Image.asset(
                          'images/app_logo.png',
                          width: mediaQuery.size.width * 0.3,
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.03),
                      SizedBox(
                        width: progressBarWidth,
                        height: progressBarHeight,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(seconds: 4),
                          builder: (context, value, child) {
                            return LiquidLinearProgressIndicator(
                              value: value,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[500]!),
                              backgroundColor: Colors.blue[100]!,
                              borderColor: Colors.blue[900]!,
                              borderWidth: 2.0,
                              borderRadius: 10.0,
                              direction: Axis.horizontal,
                              center: Text(
                                '${(value * 100).toStringAsFixed(0)}%',
                                style: TextStyle(color: Colors.blue[900]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;

  WavePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path();

    double waterHeight = size.height * (1 - animation.value);

    path.moveTo(0, size.height);
    path.lineTo(0, waterHeight);

    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        waterHeight + 20 * math.sin((i / size.width * 2 * math.pi) + (animation.value * 2 * math.pi))
      );
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
