import 'package:get/get.dart';
import 'package:sphere_vendor/controller/add_promo_screen_controller.dart';
import 'package:sphere_vendor/controller/change_password_screen_controller.dart';
import 'package:sphere_vendor/controller/edit_promo_screen_controller.dart';
import 'package:sphere_vendor/controller/home_redeem_inside_screen_controller.dart';
import 'package:sphere_vendor/controller/vendor_active_screen_controller.dart';
import 'package:sphere_vendor/controller/vendor_draft_screen_controller.dart';
import 'package:sphere_vendor/controller/vendor_hidden_screen_cotroller.dart';
import 'package:sphere_vendor/controller/vendor_home_screen_controller.dart';

import '../controller/custom_navigation_drawer.dart';
import '../controller/email_verification_screen_controller.dart';
import '../controller/initia_screen_controller.dart';
import '../controller/login_screen_controller.dart';
import '../controller/notification_screen_controller.dart';
import '../controller/reset_password_screen_controller.dart';
import '../controller/signup_screen_controller.dart';
import '../controller/splash_screen_controller.dart';
import '../controller/update_password_screen_controller.dart';
import '../controller/vendor_profile_screen_controller.dart';



class ScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut(() => LoginScreenController());
    Get.lazyPut(() => ResetPasswordScreenController());
    Get.lazyPut(() => EmailVerificationScreenController());
    Get.lazyPut(() => SignUpScreenController());
    Get.lazyPut(() => CustomNavigationDrawerController());
    Get.lazyPut(() => VendorProfileScreenController());
    Get.lazyPut(() => InitialScreenController());
    Get.lazyPut(() => VendorHomeScreenController());
    Get.lazyPut(() => AddPromoScreenController());
    Get.lazyPut(() => HomeScreenDetailRedeemScreenController());
    Get.lazyPut(() => VendorHiddenScreenController());
    Get.lazyPut(() => VendorDraftScreenController());
    Get.lazyPut(() => VendorActiveScreenController());
    Get.lazyPut(() => NotificationScreenController());
    Get.lazyPut(() => ChangePasswordScreenController());
    Get.lazyPut(() => UpdatePasswordScreenController());
    Get.lazyPut(() => EditPromoScreenController());
  }
}