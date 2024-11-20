import 'package:permission_handler/permission_handler.dart';

// Request storage permission method
Future<bool> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.request();
  if (status.isGranted) {
    return true;
  } else {
    return false;
  }
}