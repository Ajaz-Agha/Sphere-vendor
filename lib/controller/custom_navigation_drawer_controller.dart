import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sphere_vendor/model/user_login_model.dart';
import 'package:sphere_vendor/web_services/user_service.dart';

import '../screens/custom_widget/custom_dialog.dart';
import '../utils/app_constants.dart';
import '../utils/user_session_management.dart';

class CustomNavigationDrawerController extends GetxController{
RxBool isTap=false.obs;
RxBool isPromotionOption=false.obs;
  Future<void> onDrawerItemClick({required String title}) async {
   // isTap.value=!isTap.value;
    if(title!='My Promotions') {
      Get.back();
    }
    if (title == "User Profile") {
      Get.offAllNamed(kVendorProfileScreen);
    }
    else if (title == "My Promotions") {
     isPromotionOption.value=!isPromotionOption.value;
    }else if(title=="Active"){
      Get.offNamed(kVendorActiveScreen);
    }else if(title=="Draft"){
      Get.offNamed(kVendorDraftScreen);
    } else if (title == "Notifications") {
      Get.toNamed(kNotificationScreen);
    }else if (title == "Settings") {
      Get.toNamed(kUpdatePasswordScreen);
    }else if (title == "Terms of Service") {
      Get.toNamed(kGeneralScreen,arguments: title);
    }else if(title == "LOGOUT"){
      CustomDialogs().confirmationDialog(
          message: "Are you sure you want to logout?",
          yesFunction: (){
            UserService().userLogOut();
            UserSession().logOut();
            Get.offAllNamed(kLoginScreen);
          }
      );
    }else if(title=='Share'){
      Share.share('https://sphereVendor.net');
    }

  }
UserSession userSession=UserSession();
  Rx<UserLoginModel> userLoginModel=UserLoginModel.empty().obs;
  @override
  void onInit() {
    getUserFromSession();
    super.onInit();
  }

  Future<void> getUserFromSession() async{
    userLoginModel.value=await userSession.getUserLoginModel();
  }
}