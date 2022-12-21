import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/model/forgot_password_model.dart';
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

  ForgotPasswordModel fPasswordModel=ForgotPasswordModel();

  String email='';
  RxString otpCode=''.obs;

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
      ProgressDialog pd = ProgressDialog();
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