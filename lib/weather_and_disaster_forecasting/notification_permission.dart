import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class NotificationPermission {
  // Request notification permission for Android
  Future<bool> requestNotificationPermission() async {
    // Requesting permission to show notifications
    PermissionStatus status = await Permission.notification.request();

    // Check the status of the permission
    if (status.isGranted) {
      if (kDebugMode) {
        print("Notification permission granted");
      }
      return true;
    } else if (status.isDenied) {
      if (kDebugMode) {
        print("Notification permission denied");
      }
      // Handle the case where the user denies the permission
      return false;
    } else if (status.isPermanentlyDenied) {
      if (kDebugMode) {
        print("Notification permission permanently denied");
      }
      // Direct the user to the app settings if they permanently denied the permission
      openAppSettings();
      return false;
    } else {
      if (kDebugMode) {
        print("Notification permission status is unknown");
      }
      return false;
    }
  }

  // You can also check if the permission is granted before proceeding
  Future<bool> isNotificationPermissionGranted() async {
    PermissionStatus status = await Permission.notification.status;
    return status.isGranted;
  }

  // Initialization method without Flutter Local Notifications
  Future<void> initializeNotifications() async {
    bool permissionGranted = await requestNotificationPermission();

    if (permissionGranted) {
      if (kDebugMode) {
        print("Notifications can now be sent to the user.");
      }
      // Any additional setup related to notifications can be done here
    } else {
      if (kDebugMode) {
        print("Notification permissions not granted. Notifications will not be sent.");
      }
    }
  }
}
