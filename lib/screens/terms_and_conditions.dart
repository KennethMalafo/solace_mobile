import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solace_mobile_frontend/screens/home_screen.dart';
import 'package:solace_mobile_frontend/weather_and_disaster_forecasting/saving_user_auth.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  TermsAndConditionsScreenState createState() =>
      TermsAndConditionsScreenState();
}

class TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool isChecked = false;
  late String userId;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    userId = await AuthHelper.getOrCreateUserId();
    
    // Check if the user document exists
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    
    if (!userDoc.exists) {
      // Create the document with default values
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'hasAcceptedTerms': false, // Default value
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Retrieve if the user has accepted terms
      final hasAcceptedTerms = userDoc.data()?['hasAcceptedTerms'] ?? false;

      if (hasAcceptedTerms) {
        // Navigate to the HomeScreen if terms are already accepted
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    }
  }

  Future<void> _acceptTerms(BuildContext context) async {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    
    // Ensure the document exists before updating
    final userDoc = await userDocRef.get();
    if (!userDoc.exists) {
      await userDocRef.set({
        'hasAcceptedTerms': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await userDocRef.update({'hasAcceptedTerms': true});
    }

    // Navigate to the HomeScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

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
    backgroundColor: Colors.blue[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SolAce RiverWatch Terms and Conditions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
  '''Welcome to SolAce RiverWatch. By using this app, you agree to the following terms and conditions:

1. **General Terms**: By using the app, you agree to comply with the terms outlined in this agreement. You are accessing the app anonymously and do not need to create an account.
   
2. **User Responsibilities**: You must provide accurate information when using the app. You agree to use the app responsibly and not misuse any of its features. Misuse may result in limited access to certain services within the app.

3. **App Features**: The app includes water level monitoring, weather forecasts, evacuation plans, notifications, and disaster reporting. These features are provided for your safety and the better management of local disasters.

4. **Privacy**: While you do not need to log in, the app may collect location data and other information related to your usage (e.g., water levels, reports, email, and phone number). This data is used solely for the purpose of improving disaster management services and safety alerts. Your data will not be shared with third parties without your consent, except where required by law.

5. **Liability**: MDRRMO is not liable for any damages, loss, or injury caused by the use of this app, including, but not limited to, incorrect or delayed information provided by the system. Use the app at your own risk.

6. **Prohibited Activities**: Users must not use the app to:
   - Harass, intimidate, or harm others.
   - Interfere with the app’s normal operations or security features.
   - Submit false or misleading disaster reports.

7. **Indemnity**: You agree to indemnify and hold harmless MDRRMO, its partners, and affiliates from any claims, damages, or liabilities arising from your use of the app, including legal costs.

8. **Third-Party Services**: The app may contain links to third-party services or external websites. MDRRMO is not responsible for the content, services, or privacy practices of these third-party sites.

9. **Governing Law**: These terms and conditions will be governed by and construed in accordance with the laws of Sta. Barbara, and any disputes will be resolved in the appropriate legal forums in this jurisdiction.

10. **Force Majeure**: MDRRMO will not be held liable for any delay or failure in providing services due to events outside of its control, such as natural disasters, network failures, or technical issues.

Please review and agree to the terms before proceeding.''',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                const Text("I agree to the Terms and Conditions")
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isChecked
                  ? () => _acceptTerms(context)  // Enable button if checked
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isChecked ? Colors.blue : Colors.grey,  // Change button color based on checkbox state
              ),  // Disable button if not checked
              child: const Text('Accept and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}