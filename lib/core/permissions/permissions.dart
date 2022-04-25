import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<bool> permissionServicesCall()  async {
    PermissionStatus? status;

    await permissionServices().then(
      (value) {
        if(value.isGranted == true){
          status = value;
        }
      },
    );
    if(status!.isGranted){
      return true;
    } else {
      return false;
    }
  }

  Future<PermissionStatus> permissionServices() async {
    PermissionStatus status = await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings().then(
        (value) async {
          if (value) {
            while (status.isPermanentlyDenied == true &&
                status.isGranted == false) {
              openAppSettings();
            }
          }
        },
      );
    }
    return await Permission.storage.status;
  }
}
