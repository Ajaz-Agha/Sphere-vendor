import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler{
  Future<bool> requestPermission({required Permission permission,required Function onPermissionDenied,required Function onPermissionPermanentlyDenied}) async{
    print('===================${await permission.status}');
    if(await permission.isGranted){
      return true;
    }
    else{
      PermissionStatus result=await permission.request();
      if(result==PermissionStatus.granted){
        return true;
      }
      else if(result == PermissionStatus.denied){
        onPermissionDenied();
        return false;
      }
      else if(result == PermissionStatus.permanentlyDenied){
        onPermissionPermanentlyDenied();
        return false;
      }
      else{
        return false;
      }
    }
  }
}