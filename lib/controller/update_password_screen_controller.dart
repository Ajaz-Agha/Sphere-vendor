import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/user_login_model.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../utils/user_session_management.dart';
import '../web_services/user_service.dart';

class UpdatePasswordScreenController extends GetxController{

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode oldPasswordFocusNode = FocusNode();

  RxBool passwordErrorMsgVisibility = false.obs;
  RxBool confirmPasswordErrorMsgVisibility = false.obs;
  RxBool oldPasswordErrorMsgVisibility = false.obs;
  RxBool obscured = true.obs;

  RxString passwordTFErrorMsg = "".obs;
  RxString confirmPasswordTFErrorMsg = "".obs;
  RxString oldPasswordTFErrorMsg = "".obs;

  UserSession userSession = UserSession();
  Rx<UserLoginModel> userLoginModelFromSession=UserLoginModel.empty().obs;
  Future<void> getUserFromSession() async{
    userLoginModelFromSession.value=await userSession.getUserLoginModel();
  }


  Future<bool> onWillPop() {
    Get.back();
    return Future.value(false);
  }

  void removeAFieldsFocus() {
   if (oldPasswordFocusNode.hasFocus) {
      oldPasswordFocusNode.unfocus();
    } else if (passwordFocusNode.hasFocus) {
      passwordFocusNode.unfocus();
    } else if (confirmPasswordFocusNode.hasFocus) {
      confirmPasswordFocusNode.unfocus();
    }
  }


  @override
  void onInit() {
    getUserFromSession();
    super.onInit();
  }


  bool confirmPasswordValidation(String value) {
    if (value.trim() == "") {
      confirmPasswordErrorMsgVisibility.value = true;
      confirmPasswordTFErrorMsg.value = "Confirm Password is required!";
    }
/*    else if (confirmPasswordController.text.trim().length < 3 ||
        confirmPasswordController.text.trim().isEmpty) {
      confirmPasswordErrorMsgVisibility.value = true;
      confirmPasswordTFErrorMsg.value = "Invalid Confirm Password!";
    } */
    else if (!validateBothPassword()) {
      confirmPasswordErrorMsgVisibility.value = true;
      confirmPasswordTFErrorMsg.value = "Passwords does not match";
    } else {
      confirmPasswordErrorMsgVisibility.value = false;
      confirmPasswordTFErrorMsg.value = "";
    }
    return confirmPasswordErrorMsgVisibility.value;
  }

  bool passwordValidation(String value) {
    if (value.trim() == "") {
      passwordErrorMsgVisibility.value = true;
      passwordTFErrorMsg.value = "Password is required!";
    } else if (value.trim().length < 8 ||
        value.isEmpty) {
      passwordErrorMsgVisibility.value = true;
      passwordTFErrorMsg.value = "Password should be of at least 8 Characters!";
    }else if(!value.trim().contains(RegExp(r'^(?=.*?[A-Z])'))){
      passwordErrorMsgVisibility.value = true;
      passwordTFErrorMsg.value = "Password should be contain at least 1 capital letter";
    }
    else {
      passwordErrorMsgVisibility.value = false;
      passwordTFErrorMsg.value = "";
      if(passwordController.text.isNotEmpty){
        confirmPasswordValidation(value);
      }
    }
    return passwordErrorMsgVisibility.value;
  }

  bool oldPasswordValidation(String value) {
    if (value.trim() == "") {
      oldPasswordErrorMsgVisibility.value = true;
      oldPasswordTFErrorMsg.value = "Old Password is required!";
    } else if (value.trim().length < 8 ||
        value.isEmpty) {
      oldPasswordErrorMsgVisibility.value = true;
      oldPasswordTFErrorMsg.value = "Password should be of at least 8 Characters!";
    }else if(!value.trim().contains(RegExp(r'^(?=.*?[A-Z])'))){
      oldPasswordErrorMsgVisibility.value = true;
      oldPasswordTFErrorMsg.value = "Password should be contain at least 1 capital letter";
    }
    else {
      oldPasswordErrorMsgVisibility.value = false;
      oldPasswordTFErrorMsg.value = "";
    }
    return oldPasswordErrorMsgVisibility.value;
  }


  //Methods
  void toggleObscured() {
    obscured.value = !obscured.value;
    if (passwordFocusNode.hasPrimaryFocus) {
      return;
    }
    passwordFocusNode.canRequestFocus = false;
  }

  bool validateBothPassword(){
    return confirmPasswordController.text == passwordController.text &&
        passwordController.text.length >= 8 &&
        confirmPasswordController.text.length >= 8;
  }

  Future<void> changePasswordButtonPressed() async {
    removeAFieldsFocus();
    bool isAllDataValid = false;
    isAllDataValid = !oldPasswordValidation(oldPasswordController.text);
    isAllDataValid = !passwordValidation(passwordController.text) && isAllDataValid;
    isAllDataValid = !confirmPasswordValidation(confirmPasswordController.text) && isAllDataValid;
    if (isAllDataValid) {
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        String response=await UserService().changeOldPassword(email: userLoginModelFromSession.value.userDetailModel.uAccEmail, password: passwordController.text, confirmPassword: confirmPasswordController.text, oldPassword: oldPasswordController.text);
        if (response=='Password has been changed successfully') {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
            title: "Success",
            description: response,
            type: DialogType.SUCCES,
            onOkBtnPressed: () =>
                Get.back(),
          );
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
              title: "Alert",
              description: response,
              type: DialogType.ERROR);
        }
      } else{
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(title: 'Alert',
            description: kInternetMsg,
            type: DialogType.ERROR);
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}