import 'package:get/get.dart';

import '../utils/app_constants.dart';

//created by Abdul Rafay on 12-11-2022
class SplashScreenController extends GetxController{
void onLoginTap(){
  Get.offNamed(kLoginScreen);
}

void onJoinNowTap(){
  Get.offNamed(kSignupScreen);
}
}