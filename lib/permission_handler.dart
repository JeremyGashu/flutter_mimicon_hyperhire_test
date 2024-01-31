import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestStoragePermissions() async {
    // final plugin = DeviceInfoPlugin();

    final permission = await Permission.storage.request();
    return permission.isGranted;
  }
}
