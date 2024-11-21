import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solace_mobile_frontend/screens/home_screen.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  TermsAndConditionsScreenState createState() => TermsAndConditionsScreenState();
}

class TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool isChecked = false; // Track the checkbox state

  @override
  Widget build(BuildContext context) {
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
      ),
      backgroundColor: Colors.blue[100], // Set the background color
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // Black text for title
            ),
            const SizedBox(height: 20),
            const Text(
              "Please read and accept the terms and conditions to proceed.\n\n"
              '1. Introduction\n\n'
              'Welcome to SolAce RiverWatch! By accessing or using this app, you agree to abide by the terms and conditions outlined below. If you do not agree with any of these terms, please refrain from using the app.\n\n'
              '2. Purpose\n\n'
              'The purpose of this app is to provide users with real-time river water level monitoring, weather forecasts, disaster management updates, evacuation plans, and reporting features.\n\n'
              '3. User Responsibilities\n\n'
              'Users are responsible for ensuring that the information they provide is accurate. Users must use the app for its intended purpose only.\n\n'
              '4. Data Privacy\n\n'
              'The app collects certain user data, including location and reports of disasters, to provide services like weather forecasting and evacuation management. This data will be used solely for the purposes of improving safety and disaster management.\n\n'
              '5. Notification Consent\n\n'
              'By using this app, you agree to receive notifications regarding river status, alerts, evacuation plans, and other relevant information. You can opt-out of notifications in the app settings.\n\n'
              '6. Liability Disclaimer\n\n'
              'SolAce RiverWatch is not liable for any damages or loss incurred due to reliance on the information provided by the app. Always follow official government and local authorities’ instructions in case of disaster.\n\n'
              '7. User-Generated Content\n\n'
              'Users may submit reports and images regarding disasters. By submitting content, users grant SolAce RiverWatch the right to use, display, and share the content for disaster management purposes.\n\n',
              //'8. Modifications\n\n'
              //'We reserve the right to modify or update these terms at any time. Any changes will be communicated through the app.\n\n',
              style: TextStyle(fontSize: 16, color: Colors.black), // Black text for content
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "I agree to the Terms and Conditions",
                    style: TextStyle(fontSize: 16, color: Colors.black), // Black text for checkbox label
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isChecked
                  ? () async {
                      // Save user acceptance in Firestore
                      await saveTermsAcceptance();

                      // Schedule navigation to the next frame to ensure it's outside async
                      if (mounted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        });
                      }
                    }
                  : null, // Disable button if checkbox is not checked
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: isChecked ? Colors.blue[800] : Colors.grey, // Change color based on checkbox 
              ),
              child: const Text('I Agree'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> saveTermsAcceptance() async {
  try {
    String deviceId = await _getDeviceId();

    // Save or update the record in Firestore
    await FirebaseFirestore.instance
        .collection('terms_accepted')
        .doc(deviceId)
        .set({
      'termsAccepted': true,
      'acceptedAt': Timestamp.now(),
    }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
  } catch (e) {
    if (kDebugMode) {
      print("Error saving terms acceptance: $e");
    }
  }
}

Future<String> _getDeviceId() async {
  // Simulate fetching a unique device ID
  var uuid = const Uuid();
  return uuid.v4();
}
}