import 'dart:developer';

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

class LoginScreenController extends GetxController with GetSingleTickerProviderStateMixin{
  late TabController tabController;
  RxInt selectedIndex=0.obs;
  TextEditingController emailTEController = TextEditingController();
  TextEditingController passwordTEController = TextEditingController();
  RegExp emailRegex = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  RxBool emailErrorVisible = RxBool(false);
  RxString emailErrorMsg = "".obs;
  RxBool passwordErrorVisible = RxBool(false);
  RxString passwordErrorMsg = "".obs;
  RxBool obscured = true.obs;

  FocusNode emailFocusNode = FocusNode(),
      passwordFocusNode = FocusNode();

  UserSession userSession = UserSession();
  @override
  void onInit() {
    tabController=TabController(length: 2, vsync: this)..addListener(() {
      selectedIndex.value=tabController.index;

    });
    super.onInit();
  }

  bool emailValidation(String value) {
    if (value.trim() == "") {
      if(emailTEController.text.isEmpty){
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
    }else if (passwordTEController.text.trim().length < 8 ||
        passwordTEController.text.isEmpty) {
      passwordErrorVisible.value = true;
      passwordErrorMsg.value = "Password should be of at least 8 Characters!";
    }else if(!passwordTEController.text.trim().contains(RegExp(r'^(?=.*?[A-Z])'))){
      passwordErrorVisible.value = true;
      passwordErrorMsg.value = "Password should be contain at least 1 capital letter";
    }
    else {
      passwordErrorVisible.value = false;
      passwordErrorMsg.value = "";
    }
    return passwordErrorVisible.value;
  }

  void removeFocus(){
    if(emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
    }
    if(passwordFocusNode.hasFocus) {
      passwordFocusNode.unfocus();
    }
  }

  void onRestPasswordTap(){
    Get.toNamed(kResetPasswordScreen);
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
    isAllDataValid =  !emailValidation(emailTEController.text);
    isAllDataValid = !passwordValidation(passwordTEController.text) && isAllDataValid;

    if (isAllDataValid) {
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        UserLoginModel userLoginModel = await UserService().loginUser(
            password: passwordTEController.text,
            email: emailTEController.text);
        log('=======================>>>${userLoginModel.userDetailModel.locationModelList}');
        if (userLoginModel.token.isNotEmpty && userLoginModel.userDetailModel.role=='vendor') {
          userSession.createSession(userLoginModel: userLoginModel);
          pd.dismissDialog();
          Get.offAllNamed(kVendorHomeScreen);
        } else if(userLoginModel.userDetailModel.role=='vendor'){
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(title: "Alert",
              description: 'Email belongs to User',
              type: DialogType.ERROR);
        }else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(title: "Alert",
              description: userLoginModel.requestErrorMessage,
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
    tabController.dispose();
    emailTEController.dispose();
    passwordTEController.dispose();
    super.dispose();
  }


}