import 'package:flutter/material.dart';
import 'package:solace_mobile_frontend/screens/splash_screen.dart';

void main() {
  runApp(const SolAce());
}

class SolAce extends StatelessWidget {
  const SolAce({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Show splash screen initially
    );
  }
}