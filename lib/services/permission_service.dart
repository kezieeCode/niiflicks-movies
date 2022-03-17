import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestIOSStoragePermission() async {
    var result = await Permission.storage.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestIOSLocationPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestIOSPhotosPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestIOSCameraPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestAndroidLocationPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestAndroidStoragePermission() async {
    List<Permission> permissions = [
      Permission.storage,
      Permission.accessMediaLocation,
      Permission.manageExternalStorage,
    ];
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    if (statuses[Permission.storage] == PermissionStatus.granted &&
            statuses[Permission.accessMediaLocation] == PermissionStatus.granted
        && statuses[Permission.manageExternalStorage] == PermissionStatus.granted
        ) {
      return true;
    }
    return false;
  }

  Future<bool> requestAndroidCameraPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> hasPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    return permissionStatus == PermissionStatus.granted;
  }
}
