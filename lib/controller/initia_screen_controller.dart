import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:sphere_vendor/model/user_login_model.dart';
import 'package:sphere_vendor/screens/auth/email_verification_screen.dart';
import 'package:sphere_vendor/screens/home/vendor_home_screen.dart';
import 'package:sphere_vendor/screens/profile/vendor_profile_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/custom_widget/myWidgets.dart';
import '../utils/user_session_management.dart';

class InitialScreenController extends GetxController{
  String logoImage=Img.get('sphere_logo.png');
  final RxDouble splashLoading = 0.0.obs;
  Timer? timer;
  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(
      const Duration(milliseconds: 50),
          (timer) {
        splashLoading.value += 0.025;
        if (splashLoading.value >= 1.0) {
          navigate();
          timer.cancel();
        }
      },
    );
  }

  Future<void> navigate() async{
    UserSession userSession = UserSession();
    if(await userSession.isUserLoggedIn()) {
      UserLoginModel userLoginModel=await userSession.getUserLoginModel();
      if(userLoginModel.userDetailModel.firstName!='' && userLoginModel.userDetailModel.lastName!='' && userLoginModel.userDetailModel.phone!=''){
        Get.off(
                ()=> const VendorHomeScreen(),
            duration: const Duration(seconds: 1),
            transition: Transition.rightToLeftWithFade
        );
      }else{
        Get.off(
                ()=> const VendorProfileScreen(),
            duration: const Duration(seconds: 1),
            transition: Transition.rightToLeftWithFade
        );
      }

    }else{
      Get.off(
              ()=> const SplashScreen(),
          duration: const Duration(seconds: 1),
          transition: Transition.rightToLeftWithFade
      );
    }
  }
}