import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:solace_mobile_frontend/screens/notification_page.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background Message - Title: ${message.notification?.title}');
  }
  if (kDebugMode) {
    print('Background Message - Body: ${message.notification?.body}');
  }
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isNotificationPageOpen = false; // Track if NotificationPage is open

  Future<void> initNotification(BuildContext context) async {
    // Request permission for notifications (important for iOS)
    await _firebaseMessaging.requestPermission();

    // Get and save the FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      await saveTokenToFirestore(fcmToken);
      await fetchAndPrintTokenFromFirestore();
    }

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null && !_isNotificationPageOpen) {
        _navigateToNotificationPage(context, message.notification!.title, message.notification!.body);
      }
    });

    // Handle notification tap when the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null && !_isNotificationPageOpen) {
        _navigateToNotificationPage(context, message.notification!.title, message.notification!.body);
      }
    });

    // Handle notification tap when the app is completely closed
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.notification != null && !_isNotificationPageOpen) {
      _navigateToNotificationPage(context, initialMessage.notification!.title, initialMessage.notification!.body);
    }
  }

  Future<void> saveTokenToFirestore(String fcmToken) async {
    try {
      await _firestore.collection('device_tokens').doc(fcmToken).set({
        'FCMTOKEN': fcmToken,
      });
      if (kDebugMode) {
        print('Token saved to Firestore successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving token to Firestore: $e');
      }
    }
  }

  Future<void> fetchAndPrintTokenFromFirestore() async {
  try {
    // Get the current device's FCM token
    final fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      final snapshot = await _firestore.collection('device_tokens').doc(fcmToken).get();

      if (snapshot.exists) {
        final token = snapshot.data()?['FCMTOKEN'];
        if (kDebugMode) {
          print('Fetched FCM Token for this device: $token');
        }
      } else {
        if (kDebugMode) {
          print('No token found for this device in Firestore.');
        }
      }
    } else {
      if (kDebugMode) {
        print('Unable to fetch FCM token for this device.');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching token for this device from Firestore: $e');
    }
  }
}

    void _navigateToNotificationPage(BuildContext context, String? title, String? body) {
    if (!_isNotificationPageOpen) {
      _isNotificationPageOpen = true; // Mark NotificationPage as open
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationPage(
            title: title ?? 'No Title',
            body: body ?? 'No Body',
          ),
        ),
        (route) => route.isFirst, // This keeps the HomeScreen at the bottom of the stack
      ).then((_) {
        _isNotificationPageOpen = false; // Reset when NotificationPage is closed
      });
    }
  }
}
