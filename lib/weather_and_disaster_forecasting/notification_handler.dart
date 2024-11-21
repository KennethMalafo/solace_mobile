import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solace_mobile_frontend/screens/notification_page.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background Message - Title: ${message.notification?.title}');
    print('Background Message - Body: ${message.notification?.body}');
  }
}

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isNotificationPageOpen = false; // Track if NotificationPage is open

  // Initialize notifications and setup Firebase Messaging
  Future<void> initNotification(BuildContext context) async {
    if (Platform.isAndroid) {
      // Check Android version for permission handling
      if (Platform.version.contains("13") || int.tryParse(Platform.version.split('.')[0])! >= 13) {
        // For Android 13+, request notification permission
        final permissionStatus = await Permission.notification.status;
        if (permissionStatus.isDenied) {
          final requestStatus = await Permission.notification.request();
          if (!requestStatus.isGranted) {
            if (kDebugMode) {
              print('Notification permission denied.');
            }
            return; // Exit if permission is denied
          }
        }
      } else {
        // For Android < 13, notification permissions are granted automatically
        if (kDebugMode) {
          print('No need to request notification permission on Android < 13.');
        }
      }
    }

    // Proceed with Firebase Messaging setup
    await _firebaseMessaging.requestPermission();

    // Get and save the FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      await saveTokenToFirestore(fcmToken);
    }

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null && !_isNotificationPageOpen) {
        // Defer navigation safely using addPostFrameCallback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) { // Check if context is still mounted
            _navigateToNotificationPage(context, message.notification!.title, message.notification!.body);
          }
        });
      }
    });

    // Handle notification tap when the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null && !_isNotificationPageOpen) {
        // Defer navigation safely using addPostFrameCallback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) { // Check if context is still mounted
            _navigateToNotificationPage(context, message.notification!.title, message.notification!.body);
          }
        });
      }
    });

    // Handle notification tap when the app is completely closed
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.notification != null && !_isNotificationPageOpen) {
      // Defer navigation safely using addPostFrameCallback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) { // Check if context is still mounted
          _navigateToNotificationPage(context, initialMessage.notification!.title, initialMessage.notification!.body);
        }
      });
    }
  }

  // Save the FCM token to Firestore
  Future<void> saveTokenToFirestore(String fcmToken) async {
    try {
      await _firestore.collection('device_tokens').doc(fcmToken).set({
        'FCMTOKEN': fcmToken,
      });
      if (kDebugMode) {
        print('Token saved to Firestore successfully: $fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving token to Firestore: $e');
      }
    }
  }

  // Navigate to the NotificationPage when a notification is received
  void _navigateToNotificationPage(BuildContext context, String? title, String? body) {
    if (!_isNotificationPageOpen) {
      _isNotificationPageOpen = true; // Mark NotificationPage as open

      // Use Navigator to go to NotificationPage
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