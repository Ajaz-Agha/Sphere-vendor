import 'package:get/get.dart';
import 'package:sphere_vendor/screens/auth/change_password_screen.dart';
import 'package:sphere_vendor/screens/home/add_promo_screen.dart';
import 'package:sphere_vendor/screens/home/home_redeem_inside_screen.dart';
import 'package:sphere_vendor/screens/home/vendor_home_screen.dart';
import 'package:sphere_vendor/screens/my_promotions/edit_promo_screen.dart';
import 'package:sphere_vendor/screens/my_promotions/vendor_active_screen.dart';
import 'package:sphere_vendor/screens/my_promotions/vendor_draft_screen.dart';
import 'package:sphere_vendor/screens/my_promotions/vendor_hidden_screen.dart';
import 'package:sphere_vendor/screens/profile/vendor_profile_screen.dart';
import 'package:sphere_vendor/screens/update_password/update_password_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/auth/initial_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/notification/notification_screen.dart';
import 'app_constants.dart';
import 'screen_bindings.dart';

class RouteGenerator {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: kSplashScreen,
        page: () => const SplashScreen(),
          binding: ScreenBindings(),
      ),
      GetPage(
        name: kLoginScreen,
        page: () => const LoginScreen(),
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kResetPasswordScreen,
        page: () => const ResetPasswordScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kEmailVerificationScreen,
        page: () => const EmailVerificationScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kSignupScreen,
        page: () => const SignupScreen(),
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kInitialScreen,
        page: () => const InitialScreen(),
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kVendorHomeScreen,
        page: () => const VendorHomeScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kVendorProfileScreen,
        page: () => const VendorProfileScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kAddPromoScreen,
        page: () => const AddPromoScreen(),
        transition: Transition.size,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kEditPromoScreen,
        page: () => const EditPromoScreen(),
        transition: Transition.size,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kInsideHomeRedeemScreen,
        page: () => const HomeScreenDetailRedeemScreen(),
        transition: Transition.zoom,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kVendorHiddenScreen,
        page: () => const VendorHiddenScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kVendorDraftScreen,
        page: () => const VendorDraftScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kVendorActiveScreen,
        page: () => const VendorActiveScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kChangePasswordScreen,
        page: () => const ChangePasswordScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kNotificationScreen,
        page: () => const NotificationScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
      GetPage(
        name: kUpdatePasswordScreen,
        page: () => const UpdatePasswordScreen(),
        transition: Transition.leftToRight,
        transitionDuration: pageTransitionDuration,
        binding: ScreenBindings(),
      ),
    ];
  }


}