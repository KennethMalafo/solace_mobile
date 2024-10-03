import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:solace_mobile_frontend/tipspages/barangay_evacuation_guide.dart';
import 'package:solace_mobile_frontend/tipspages/bagyo_at_baha.dart';
import 'package:solace_mobile_frontend/tipspages/lindol.dart';
import 'package:solace_mobile_frontend/tipspages/ldrrmc.dart';

class LigtasTips extends StatelessWidget {
  const LigtasTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Image(
                      image: AssetImage('images/mdrrmo.png'),
                      width: 200,
                      height: 235,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Barangay Evacuation Guide Section
                  buildSection(
                    context,
                    'Barangay Evacuation Guide',
                    'Learn the necessary steps to safely evacuate in case of emergency in your barangay. '
                    'Follow these steps and know your local shelters.',
                    const BarangayEvacuationGuide(),
                    Icons.location_city,
                    [Colors.greenAccent, Colors.teal],
                  ),
                  const SizedBox(height: 20),

                  // Bagyo at Baha Section
                  buildSection(
                    context,
                    'Bagyo at Baha',
                    'Prepare yourself for storms and floods by following these essential steps. '
                    'Stay informed and keep safe during extreme weather events.',
                    const BagyoAtBaha(),
                    Icons.cloud,
                    [Colors.lightBlueAccent, Colors.blue[900]!],
                  ),
                  const SizedBox(height: 20),

                  // Lindol Section
                  buildSection(
                    context,
                    'Lindol',
                    'Earthquakes can be dangerous. Learn the safety tips to protect yourself and your loved ones during a seismic event.',
                    const LindolGuide(),
                    Icons.warning_amber_rounded,
                    [Colors.redAccent[100]!, Colors.pink],
                  ),
                  const SizedBox(height: 20),

                  // LDRRMC Section
                  buildSection(
                    context,
                    'LDRRMC',
                    'Your Local Disaster Risk Reduction and Management Council is here to help. Learn how they can assist in times of crisis.',
                    const LDRRMC(),
                    Icons.groups,
                    [Colors.orange[300]!, Colors.deepOrangeAccent],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build a section with title, description, and button
  Widget buildSection(BuildContext context, String title, String description, Widget nextPage, IconData icon, List<Color> gradientColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 15),
        buildFrostedGlassButton(context, title, nextPage, icon, gradientColors),
      ],
    );
  }

  // Frosted glass button with hover effect
  Widget buildFrostedGlassButton(BuildContext context, String text, Widget nextPage, IconData icon, List<Color> gradientColors) {
    return Tooltip(
      message: 'Tap to open $text',
      child: HoverButton(
        text: text,
        icon: icon,
        gradientColors: gradientColors,
        onPressed: () {
          Navigator.of(context).push(_createRoute(nextPage));
        },
      ),
    );
  }

  // Slide page transition
  Route _createRoute(Widget nextPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class HoverButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final List<Color> gradientColors;

  const HoverButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.gradientColors,
  });

  @override
  HoverButtonState createState() => HoverButtonState();
}

class HoverButtonState extends State<HoverButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => _animateScale(1.05),
      onTapUp: (_) => _animateScale(1.0),
      onTapCancel: () => _animateScale(1.0),
      child: Transform.scale(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Card(
              elevation: 8.0,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 30),
                      const SizedBox(width: 12),
                      Text(
                        widget.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _animateScale(double scale) {
    setState(() {
      _scale = scale;
    });
  }
}