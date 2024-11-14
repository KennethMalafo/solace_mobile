import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final String title;
  final String body;

  const NotificationPage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to HomeScreen
            Navigator.pop(context);
          },
        ),
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
      ),
      backgroundColor: Colors.blue[100],
      body: Stack(
        children: [
          // Background image with opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'images/mdrrmo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications,
                    size: screenWidth * 0.2,
                    color: Colors.blue[900],
                  ),
                  const SizedBox(height: 20),
                  // Notification card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            body,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
