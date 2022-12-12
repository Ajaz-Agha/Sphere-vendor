import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../web_services/verify_email.dart';

class EmailVerificationScreenController extends GetxController{
  TextEditingController firstOtpDigit = TextEditingController();
  TextEditingController secondOtpDigit = TextEditingController();
  TextEditingController thirdOtpDigit = TextEditingController();
  TextEditingController fourthOtpDigit = TextEditingController();

  FocusNode firstOtpFocusNode = FocusNode();
  FocusNode secondOtpFocusNode = FocusNode();
  FocusNode thirdOtpFocusNode = FocusNode();
  FocusNode fourthOtpFocusNode = FocusNode();

  RxBool otp1=true.obs,otp2=true.obs,otp3=true.obs,otp4=true.obs;

  String email='';

  bool onTextChange(String value){
    if(firstOtpDigit.text.length==1){
      otp1.value=false;
    }
    if(secondOtpDigit.text.length==1){
      otp2.value=false;
    }
    if(thirdOtpDigit.text.length==1){
      otp3.value=false;
    }
    if(fourthOtpDigit.text.length==1){
      otp4.value=false;
    }
    return false;
  }


/*  void removeAFieldsFocus() {
    if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
    } else if (passwordFocusNode.hasFocus) {
      passwordFocusNode.unfocus();
    } else if (confirmPasswordFocusNode.hasFocus) {
      confirmPasswordFocusNode.unfocus();
    }
  }*/

  Future<bool> onWillPop() {
    Get.offNamed(kLoginScreen);
    return Future.value(false);
  }

  @override
  void onInit() {
    email=Get.arguments;
    super.onInit();
  }

  void removeAFieldsFocus() {
    if (firstOtpFocusNode.hasFocus) {
      firstOtpFocusNode.unfocus();
    } else if (secondOtpFocusNode.hasFocus) {
      secondOtpFocusNode.unfocus();
    } else if (thirdOtpFocusNode.hasFocus) {
      thirdOtpFocusNode.unfocus();
    }else if (fourthOtpFocusNode.hasFocus) {
      fourthOtpFocusNode.unfocus();
    }
  }
  Future<void> onEmailVerify() async{
    removeAFieldsFocus();
    String otpCode='';
    if(firstOtpDigit.text!='' && secondOtpDigit.text!='' && thirdOtpDigit.text!='' && fourthOtpDigit.text!=''){
      otpCode='${firstOtpDigit.text}${secondOtpDigit.text}${thirdOtpDigit.text}${fourthOtpDigit.text}';
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        String response = await  VerifyAccountService().verifyAccount(verifyCode: otpCode,email: email);
        pd.dismissDialog();
        if (response!='' && response=='Account activated successfully') {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
            title: "Success",
            description: "Verified Successfully!",
            type: DialogType.SUCCES,
            onOkBtnPressed: () => Get.offNamed(kLoginScreen),
          );
        } else {
          pd.dismissDialog();
          firstOtpDigit.clear();
          secondOtpDigit.clear();
          thirdOtpDigit.clear();
          fourthOtpDigit.clear();
          otp1.value=true;
          otp2.value=true;
          otp3.value=true;
          otp4.value=true;
          CustomDialogs().showMessageDialog(
              title: "Alert", description: response, type: DialogType.ERROR);
        }
      } else{
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(title: 'Alert',
            description: kInternetMsg,
            type: DialogType.ERROR);
      }
    }else{
      CustomDialogs().showMessageDialog(title: 'Alert',
          description: 'OTP Code is Empty',
          type: DialogType.ERROR);
    }



  }
}