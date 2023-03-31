import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_login_model.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../utils/user_session_management.dart';
import '../web_services/user_service.dart';

class LoginScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt selectedIndex = 0.obs;
  TextEditingController emailTEController = TextEditingController();
  TextEditingController passwordTEController = TextEditingController();
  RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  RxBool emailErrorVisible = RxBool(false);
  RxString emailErrorMsg = "".obs;
  RxBool passwordErrorVisible = RxBool(false);
  RxString passwordErrorMsg = "".obs;
  RxBool obscured = true.obs, isRemember = false.obs;

  FocusNode emailFocusNode = FocusNode(), passwordFocusNode = FocusNode();

  UserSession userSession = UserSession();

  RxMap<String, dynamic> userDataMap = <String, dynamic>{}.obs;

  RxString deviceTokenToSendPushNotification = ''.obs;
  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        selectedIndex.value = tabController.index;
      });
    getDeviceTokenToSendNotification();
    super.onInit();
  }

  Future<void> fbLoginTap() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    ); // by default we request the email and the public profile
    log("RESULT STATUS: ${result.status}");
    log("MESSAGE: ${result.message}");
    log("TOKEN: ${result.accessToken}");
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      userDataMap.value = userData;
      if (userDataMap['email'] != null) {
        ProgressDialog pd = ProgressDialog();
        pd.showDialog();
        if (await CommonCode().checkInternetAccess()) {
          UserLoginModel userLoginModel = await UserService().socialLoginUser(
              email: userDataMap['email'],
              deviceToken: deviceTokenToSendPushNotification.value,
              businessName: userDataMap['name']);
          if (userLoginModel.token.isNotEmpty &&
              userLoginModel.userDetailModel.role == 'vendor') {
            userSession.createSession(userLoginModel: userLoginModel);
            pd.dismissDialog();
            if (userLoginModel.userDetailModel.firstName != '' &&
                userLoginModel.userDetailModel.lastName != '' &&
                userLoginModel.userDetailModel.phone != '') {
              Get.offAllNamed(kVendorHomeScreen);
            } else {
              Get.offAllNamed(kVendorProfileScreen);
            }
          } else if (userLoginModel.userDetailModel.role == 'user') {
            pd.dismissDialog();
            CustomDialogs().showMessageDialog(
                title: "Alert",
                description: 'Email belongs to User',
                type: DialogType.ERROR);
          } else if (userLoginModel.requestErrorMessage ==
              'Please verify your account') {
            Get.offNamed(kEmailVerificationScreen,
                arguments: emailTEController.text);
          } else {
            pd.dismissDialog();
            CustomDialogs().showMessageDialog(
                title: "Alert",
                description: userLoginModel.requestErrorMessage,
                type: DialogType.ERROR);
          }
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
              title: 'Alert',
              description: kInternetMsg,
              type: DialogType.ERROR);
        }
      } else {
        CustomDialogs().showMessageDialog(
            title: 'Alert',
            description: 'Facebook email not found',
            type: DialogType.ERROR);
      }
    } else {}
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    deviceTokenToSendPushNotification.value = token.toString();
  }

  bool emailValidation(String value) {
    if (value.trim() == "") {
      if (emailTEController.text.isEmpty) {
        emailErrorMsg.value = "Email is required!";
        emailErrorVisible.value = true;
      }
    } else if (!emailRegex.hasMatch(value)) {
      emailErrorVisible.value = true;
      emailErrorMsg.value = "Invalid Email!";
    } else {
      emailErrorVisible.value = false;
      emailErrorMsg.value = "";
    }
    return emailErrorVisible.value;
  }

  bool passwordValidation(String value) {
    if (value.trim() == "") {
      passwordErrorVisible.value = true;
      passwordErrorMsg.value = "Password is required!";
    } else if (passwordTEController.text.trim().length < 8 ||
        passwordTEController.text.isEmpty) {
      passwordErrorVisible.value = true;
      passwordErrorMsg.value = "Password should be of at least 8 Characters!";
    } else if (!passwordTEController.text
        .trim()
        .contains(RegExp(r'^(?=.*?[A-Z])'))) {
      passwordErrorVisible.value = true;
      passwordErrorMsg.value =
          "Password should be contain at least 1 capital letter";
    } else {
      passwordErrorVisible.value = false;
      passwordErrorMsg.value = "";
    }
    return passwordErrorVisible.value;
  }

  void removeFocus() {
    if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
    }
    if (passwordFocusNode.hasFocus) {
      passwordFocusNode.unfocus();
    }
  }

  void onRestPasswordTap() {
    Get.toNamed(kResetPasswordScreen);
  }

  void isRememberMeTap() {
    if (!emailValidation(emailTEController.text)) {
      isRemember.value = !isRemember.value;
    }
  }

  //Methods
  void toggleObscured() {
    obscured.value = !obscured.value;
    if (passwordFocusNode.hasPrimaryFocus) {
      return;
    }
    passwordFocusNode.canRequestFocus = false;
  }

  Future<void> onSubmitProcess() async {
    removeFocus();
    bool isAllDataValid = false;
    isAllDataValid = !emailValidation(emailTEController.text);
    isAllDataValid =
        !passwordValidation(passwordTEController.text) && isAllDataValid;

    if (isAllDataValid) {
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if (await CommonCode().checkInternetAccess()) {
        UserLoginModel userLoginModel = await UserService().loginUser(
            password: passwordTEController.text,
            email: emailTEController.text,
            deviceToken: deviceTokenToSendPushNotification.value);
        if (userLoginModel.token.isNotEmpty &&
            userLoginModel.userDetailModel.role == 'vendor') {
          print("User Token: " "${userLoginModel.token}");
          userSession.createSession(userLoginModel: userLoginModel);
          pd.dismissDialog();
          if (userLoginModel.userDetailModel.firstName != '' &&
              userLoginModel.userDetailModel.lastName != '' &&
              userLoginModel.userDetailModel.phone != '') {
            Get.offAllNamed(kVendorHomeScreen);
          } else {
            Get.offAllNamed(kVendorProfileScreen);
          }
        } else if (userLoginModel.userDetailModel.role == 'user') {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
              title: "Alert",
              description: 'Email belongs to User',
              type: DialogType.ERROR);
        } else if (userLoginModel.requestErrorMessage ==
            'Please verify your account') {
          Get.offNamed(kEmailVerificationScreen,
              arguments: emailTEController.text);
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
              title: "Alert",
              description: userLoginModel.requestErrorMessage,
              type: DialogType.ERROR);
        }
      } else {
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(
            title: 'Alert', description: kInternetMsg, type: DialogType.ERROR);
      }
    }
  }

  Future<void> onGoogleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signIn();
      if (googleSignIn.currentUser!.id != '') {
        emailTEController.text = googleSignIn.currentUser!.email;
        ProgressDialog pd = ProgressDialog();
        pd.showDialog();
        if (await CommonCode().checkInternetAccess()) {
          UserLoginModel userLoginModel = await UserService().socialLoginUser(
              email: emailTEController.text,
              deviceToken: deviceTokenToSendPushNotification.value,
              businessName: googleSignIn.currentUser!.displayName!);
          if (userLoginModel.token.isNotEmpty &&
              userLoginModel.userDetailModel.role == 'vendor') {
            userSession.createSession(userLoginModel: userLoginModel);
            pd.dismissDialog();
            if (userLoginModel.userDetailModel.firstName != '' &&
                userLoginModel.userDetailModel.lastName != '' &&
                userLoginModel.userDetailModel.phone != '') {
              Get.offAllNamed(kVendorHomeScreen);
            } else {
              Get.offAllNamed(kVendorProfileScreen);
            }
          } else if (userLoginModel.userDetailModel.role == 'user') {
            pd.dismissDialog();
            CustomDialogs().showMessageDialog(
                title: "Alert",
                description: 'Email belongs to User',
                type: DialogType.ERROR);
          } else if (userLoginModel.requestErrorMessage ==
              'Please verify your account') {
            Get.offNamed(kEmailVerificationScreen,
                arguments: emailTEController.text);
          } else {
            pd.dismissDialog();
            CustomDialogs().showMessageDialog(
                title: "Alert",
                description: userLoginModel.requestErrorMessage,
                type: DialogType.ERROR);
          }
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
              title: 'Alert',
              description: kInternetMsg,
              type: DialogType.ERROR);
        }
      }
    } catch (error) {}
  }

  @override
  void dispose() {
    tabController.dispose();
    emailTEController.dispose();
    passwordTEController.dispose();
    super.dispose();
  }
}
