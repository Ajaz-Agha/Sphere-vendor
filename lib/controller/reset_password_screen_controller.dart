import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/model/forgot_password_model.dart';
import 'package:sphere_vendor/model/user_detail_model.dart';
import 'package:sphere_vendor/utils/app_constants.dart';
import 'package:sphere_vendor/web_services/user_service.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../utils/common_code.dart';

class ResetPasswordScreenController extends GetxController{
  TextEditingController emailTEController = TextEditingController();
  RegExp emailRegex = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  RxBool emailErrorVisible = RxBool(false);
  RxString emailErrorMsg = "".obs;
  FocusNode emailFocusNode = FocusNode();

  RxBool otpWidgetVisible=false.obs,emailReadOnly=false.obs;

  Timer timer=Timer(Duration(minutes: 1), () { });
  RxInt start = 60.obs;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start.value == 0) {
            timer.cancel();
        } else {
            start.value--;
        }
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
   // startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  ForgotPasswordModel fPasswordModel=ForgotPasswordModel();

  String email='';
  RxString otpCode=''.obs;
  RxBool isResend=false.obs;

  bool emailValidation(String value) {
    if (value.trim() == "") {
      if(emailTEController.text.isEmpty){
        emailErrorMsg.value = "Email is required!";
        emailErrorVisible.value = true;
      }
    } else if (!emailRegex.hasMatch(value)) {
      emailErrorVisible.value = true;
      emailErrorMsg.value = "Please Enter a valid email address";
    } else {
      emailErrorVisible.value = false;
      emailErrorMsg.value = "";
    }
    return emailErrorVisible.value;
  }
  void removeAFieldsFocus() {
    if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
    }
  }

  void onResetEmailTap() async{
    removeAFieldsFocus();
    bool isAllDataValid = false;
    isAllDataValid = !emailValidation(emailTEController.text);
    if(isAllDataValid) {
        } ProgressDialog pd = ProgressDialog();
    pd.showDialog();
    if (await CommonCode().checkInternetAccess()) {
      ForgotPasswordModel forgotPasswordModel = await UserService().forgotPassword(email: emailTEController.text);
      if (forgotPasswordModel.responseMessage=='Email sent successfully') {
        pd.dismissDialog();
        fPasswordModel=forgotPasswordModel;
        otpWidgetVisible.value=true;
        emailReadOnly.value=true;

      } else {
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(
            title: "Alert",
            description: forgotPasswordModel.responseMessage,
            type: DialogType.ERROR);
      }
    } else {
      pd.dismissDialog();
      CustomDialogs().showMessageDialog(title: 'Alert',
          description: kInternetMsg,
          type: DialogType.ERROR);
    }

  }

  Future<void> onResendOtp() async{
    ProgressDialog pd = ProgressDialog();
    pd.showDialog(title: 'Please wait...');
    if (await CommonCode().checkInternetAccess()) {
      UserDetailModel response = await UserService().resendOTP(email: emailTEController.text);
      if (response.requestErrorMessage=='Success.') {
        pd.dismissDialog();
        fPasswordModel.code=response.otpCode;
        print('----------------->>>${otpCode.value}');
        CustomDialogs().showMessageDialog(
            title: "Success",
            description: 'Otp Resend Successfully',
            type: DialogType.ERROR);
      } else {
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(
            title: "Alert",
            description: response.requestErrorMessage,
            type: DialogType.ERROR);
      }
    } else {
      pd.dismissDialog();
      CustomDialogs().showMessageDialog(title: 'Alert',
          description: kInternetMsg,
          type: DialogType.ERROR);
    }

  }

  Future<void> onVerify() async{
    if(otpCode.value!='') {
        if (otpCode.value==fPasswordModel.code.toString()) {
          CustomDialogs().showMessageDialog(
            title: "Success",
            description: "Verified Successfully!",
            type: DialogType.SUCCES,
            onOkBtnPressed: () => Get.offNamed(kChangePasswordScreen, arguments: fPasswordModel.email),
          );
        } else {
          CustomDialogs().showMessageDialog(
              title: "Alert",
              description: 'Invalid Code!',
              type: DialogType.ERROR);
        }

    }

  }
}