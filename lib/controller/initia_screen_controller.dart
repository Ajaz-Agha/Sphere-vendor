import 'dart:async';
import 'package:get/get.dart';
import 'package:sphere_vendor/screens/home/vendor_home_screen.dart';
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
      Get.off(
              ()=> const VendorHomeScreen(),
          duration: const Duration(seconds: 1),
          transition: Transition.rightToLeftWithFade
      );
    }else{
      Get.off(
              ()=> const SplashScreen(),
          duration: const Duration(seconds: 1),
          transition: Transition.rightToLeftWithFade
      );
    }
  }
}