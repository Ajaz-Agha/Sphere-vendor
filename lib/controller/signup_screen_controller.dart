import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/user_register_model.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../web_services/user_service.dart';

class SignUpScreenController extends GetxController{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController businessController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode businessFocusNode = FocusNode();

  RxBool emailErrorMsgVisibility = false.obs;
  RxBool passwordErrorMsgVisibility = false.obs;
  RxBool confirmPasswordErrorMsgVisibility = false.obs;
  RxBool businessErrorMsgVisibility = false.obs;
  RxBool obscured = true.obs;

  RxString emailTFErrorMsg = "".obs;
  RxString passwordTFErrorMsg = "".obs;
  RxString confirmPasswordTFErrorMsg = "".obs;
  RxString businessTFErrorMsg = "".obs;

  UserRegisterModel _userRegisterModel = UserRegisterModel.empty();
  UserService _userService = UserService();

  bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  Future<bool> onWillPop() {
    Get.back();
    return Future.value(false);
  }

  void removeAFieldsFocus() {
    if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
    } else if (passwordFocusNode.hasFocus) {
      passwordFocusNode.unfocus();
    } else if (confirmPasswordFocusNode.hasFocus) {
      confirmPasswordFocusNode.unfocus();
    }
  }

  bool emailValidation(String value) {
    if (value.trim() == "") {
      emailErrorMsgVisibility.value = true;
      emailTFErrorMsg.value = "Email is required!";
    } else if (isValidEmail(value) != true) {
      emailErrorMsgVisibility.value = true;
      emailTFErrorMsg.value = "Invalid Email!";
    } else {
      emailErrorMsgVisibility.value = false;
      emailTFErrorMsg.value = "";
    }
    return emailErrorMsgVisibility.value;
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
      if(passwordController.text.length  > 0){
        confirmPasswordValidation(value);
      }
    }
    return passwordErrorMsgVisibility.value;
  }

  bool businessValidation(String value) {
    if (value.trim() == "") {
      businessErrorMsgVisibility.value = true;
      businessTFErrorMsg.value = "Business name is required!";
    } else if (value.trim().length < 5 ||
        value.isEmpty) {
      businessErrorMsgVisibility.value = true;
      businessTFErrorMsg.value = "Invalid";
    }
    else {
      businessErrorMsgVisibility.value = false;
      businessTFErrorMsg.value = "";
    }
    return businessErrorMsgVisibility.value;
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
  Future<void> registerButtonPressed() async {
    removeAFieldsFocus();
    bool isAllDataValid = false;
    isAllDataValid = !businessValidation(businessController.text);
    isAllDataValid = !emailValidation(emailController.text) && isAllDataValid;
    isAllDataValid = !passwordValidation(passwordController.text) && isAllDataValid;
    isAllDataValid = !confirmPasswordValidation(confirmPasswordController.text) && isAllDataValid;
    if (isAllDataValid) {
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        _userRegisterModel = UserRegisterModel(
          userConfirmPassword: confirmPasswordController.text.trim(),
          userEmail: emailController.text.trim(),
          userPassword: passwordController.text.trim(),
          business: businessController.text.trim(),
        );
        UserRegisterModel userRegisterModel = await _userService.registerUser(_userRegisterModel);
        if (userRegisterModel.response=="User has been created successfully") {
          pd.dismissDialog();

          CustomDialogs().showMessageDialog(
            title: "Success",
            description: "Registered Successfully!",
            type: DialogType.SUCCES,
            onOkBtnPressed: () => Get.offNamed(kEmailVerificationScreen,arguments: userRegisterModel.userEmail),
          );
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
              title: "Alert", description: userRegisterModel.response, type: DialogType.ERROR);
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
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}