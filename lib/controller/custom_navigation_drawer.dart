
import 'package:get/get.dart';
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
    if(title!='My Promotion') {
      Get.back();
    }
    if (title == "User Profile") {
      Get.offAllNamed(kVendorProfileScreen);
    }
    else if (title == "My Promotion") {
     isPromotionOption.value=!isPromotionOption.value;
    }else if(title=="Hidden"){
      Get.toNamed(kVendorHiddenScreen);
    }else if(title=="Active"){
      Get.toNamed(kVendorActiveScreen);
    }else if(title=="Draft"){
      Get.toNamed(kVendorDraftScreen);
    } else if (title == "Notification") {
      Get.toNamed(kNotificationScreen);
    }else if (title == "Settings") {
      Get.toNamed(kUpdatePasswordScreen);
    }else if(title == "LOGOUT"){
      CustomDialogs().confirmationDialog(
          message: "Are you sure you want to logout?",
          yesFunction: (){
            UserService().userLogOut();
            UserSession().logOut();
            Get.offAllNamed(kLoginScreen);
          }
      );
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