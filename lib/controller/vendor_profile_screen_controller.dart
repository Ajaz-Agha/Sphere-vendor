import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/user_login_model.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../utils/permission_handler.dart';
import '../utils/user_session_management.dart';
import '../web_services/user_service.dart';

class VendorProfileScreenController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController fNameTEController=TextEditingController();
  TextEditingController lNameTEController=TextEditingController();
  Rx<TextEditingController> emailTEController=TextEditingController().obs;
  TextEditingController phNoTEController=TextEditingController();
  Rx<TextEditingController> businessNameTEController=TextEditingController().obs;
  TextEditingController descriptionTEController=TextEditingController();
  TextEditingController businessAddTEController=TextEditingController();

  RxList<String> linkList = <String>[].obs;

  FocusNode fNameFocusNode = FocusNode(),
      lNameFocusNode = FocusNode(),phoneFocusNode=FocusNode(),descFocusNode=FocusNode(),businessNameFocusNode=FocusNode();

  UserLoginModel userLoginModel=UserLoginModel.empty();
  Rx<File> photoImage=File('').obs;
  Rx<File> coverPhotoImage=File('').obs;

  RxBool fNameErrorVisible = RxBool(false);
  RxString fNameErrorMsg = "".obs;
  RxBool lNameErrorVisible = RxBool(false);
  RxString lNameErrorMsg = "".obs;
  RxBool phoneErrorVisible = RxBool(false);
  RxString phoneErrorMsg = "".obs;
  RxBool descriptionErrorVisible = RxBool(false);
  RxString descriptionErrorMsg = "".obs;
  RxBool businessNameErrorVisible = RxBool(false);
  RxString businessNameErrorMsg = "".obs;

  UserSession userSession = UserSession();



  Future<bool> onBackPressed() async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      Get.offNamed(kVendorHomeScreen);
      return Future.value(false);
    } else {
      Get.offNamed(kVendorHomeScreen);
      return true;

    }

  }

  Rx<UserLoginModel> userLoginModelFromSession=UserLoginModel.empty().obs;
  @override
  void onInit() {
    getUserFromSession();
    super.onInit();
  }

  Future<void> getUserFromSession() async{
    userLoginModelFromSession.value=await userSession.getUserLoginModel();
    emailTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.uAccEmail);
    businessNameTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.businessName);
  }

  void removeFocus(){
    if(fNameFocusNode.hasFocus) {
      fNameFocusNode.unfocus();
    }
    if(lNameFocusNode.hasFocus) {
      lNameFocusNode.unfocus();
    }
    if(phoneFocusNode.hasFocus) {
      phoneFocusNode.unfocus();
    }if(descFocusNode.hasFocus) {
      descFocusNode.unfocus();
    }if(businessNameFocusNode.hasFocus) {
      businessNameFocusNode.unfocus();
    }
  }
Future<void> onUploadImage() async{
  try{
    bool hasCameraPermission=await PermissionsHandler().requestPermission(permission: Permission.camera,
      onPermissionDenied:(){
        CustomDialogs().showErrorDialog(
          kPermissionDenied,
          kCameraPermissionDenied,
          DialogType.ERROR,
          Colors.red,
        );
      },
      onPermissionPermanentlyDenied: (){

        CustomDialogs().showErrorDialog(
          kPermissionDenied,
          "Camera $kPermissionPermanentlyDenied",
          DialogType.ERROR,
          Colors.red,
        );
      },
    );
    if(hasCameraPermission) {
      CustomDialogs().uploadImageDialog(onSuccess: (source){onImagePick(source);});
    }
  }catch (e){
  }
}
  Future<void> onImagePick(ImageSource source) async {
    ProgressDialog progressDialog = ProgressDialog();
    progressDialog.showDialog();
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        int index = pickedImage.path.lastIndexOf('/');
        if (index != -1) {
          File file = File(pickedImage.path);
          File compressedImage = await CommonCode().compressImage(file);
          photoImage.value=compressedImage;
          if (await CommonCode().checkInternetConnection()) {
            /* var result = await UserService().updateProfilePhoto(userAccountId: AppSettings.userLoginModel.value.uAccId, imgPath: compressedImage.path);
            if(result is ResponseModel){
              String imageName = result.data.toString().split("/").last;
              AppSettings.userLoginModel.value.profilePicPath = "uploads/${AppSettings.userLoginModel.value.uAccId}/$imageName";
              await UserSession().updateSessionData(AppSettings.userLoginModel.value);
              AppSettings.userLoginModel.refresh();
              progressDialog.dismissDialog();
            }
            else{
              progressDialog.dismissDialog();
              CustomDialogs().showDialog("Alert", result, DialogType.ERROR, Colors.red);
            }*/
            progressDialog.dismissDialog();
          } else {
            progressDialog.dismissDialog();
            CustomDialogs().showMessageDialog(
                title: 'Alert', description: kInternetMsg, type: DialogType.ERROR);
          }

        }
      }
      progressDialog.dismissDialog();
    }
    catch(exception){
      progressDialog.dismissDialog();
    }
  }

  Future<void> onUploadCoverImage() async{
    try{
      bool hasCameraPermission=await PermissionsHandler().requestPermission(permission: Permission.camera,
        onPermissionDenied:(){
          CustomDialogs().showErrorDialog(
            kPermissionDenied,
            kCameraPermissionDenied,
            DialogType.ERROR,
            Colors.red,
          );
        },
        onPermissionPermanentlyDenied: (){

          CustomDialogs().showErrorDialog(
            kPermissionDenied,
            "Camera $kPermissionPermanentlyDenied",
            DialogType.ERROR,
            Colors.red,
          );
        },
      );
      if(hasCameraPermission) {
        CustomDialogs().uploadImageDialog(onSuccess: (source){onCoverImagePick(source);});
      }
    }catch (e){
    }
  }
  Future<void> onCoverImagePick(ImageSource source) async {
    ProgressDialog progressDialog = ProgressDialog();
    progressDialog.showDialog();
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        int index = pickedImage.path.lastIndexOf('/');
        if (index != -1) {
          File file = File(pickedImage.path);
          File compressedImage = await CommonCode().compressImage(file);
          coverPhotoImage.value=compressedImage;
          if (await CommonCode().checkInternetConnection()) {
            /* var result = await UserService().updateProfilePhoto(userAccountId: AppSettings.userLoginModel.value.uAccId, imgPath: compressedImage.path);
            if(result is ResponseModel){
              String imageName = result.data.toString().split("/").last;
              AppSettings.userLoginModel.value.profilePicPath = "uploads/${AppSettings.userLoginModel.value.uAccId}/$imageName";
              await UserSession().updateSessionData(AppSettings.userLoginModel.value);
              AppSettings.userLoginModel.refresh();
              progressDialog.dismissDialog();
            }
            else{
              progressDialog.dismissDialog();
              CustomDialogs().showDialog("Alert", result, DialogType.ERROR, Colors.red);
            }*/
            progressDialog.dismissDialog();
          } else {
            progressDialog.dismissDialog();
            CustomDialogs().showMessageDialog(
                title: 'Alert', description: kInternetMsg, type: DialogType.ERROR);
          }

        }
      }
      progressDialog.dismissDialog();
    }
    catch(exception){
      progressDialog.dismissDialog();
    }
  }

  bool fNameValidation(String value) {
    if (value.trim() == "") {
      if(fNameTEController.text.isEmpty){
        fNameErrorMsg.value = "First Name is required!";
        fNameErrorVisible.value = true;
      }
    } else if (fNameTEController.text.length<=3) {
      fNameErrorVisible.value = true;
      fNameErrorMsg.value = "First name should be greater then 3";
    } else {
      fNameErrorVisible.value = false;
      fNameErrorMsg.value = "";
    }
    return fNameErrorVisible.value;
  }

  bool lNameValidation(String value) {
    if (value.trim() == "") {
      if(lNameTEController.text.isEmpty){
        lNameErrorMsg.value = "Last Name is required!";
        lNameErrorVisible.value = true;
      }
    } else if (lNameTEController.text.length<=3) {
      lNameErrorVisible.value = true;
      lNameErrorMsg.value = "Last name should be greater then 3";
    } else {
      lNameErrorVisible.value = false;
      lNameErrorMsg.value = "";
    }
    return lNameErrorVisible.value;
  }

  bool phoneValidation(String value) {
    if (value.trim() == "") {
      if(phNoTEController.text.isEmpty){
        phoneErrorMsg.value = "Phone number is required!";
        phoneErrorVisible.value = true;
      }
    } else if (phNoTEController.text.length<11 || phNoTEController.text.length>11) {
      phoneErrorVisible.value = true;
      phoneErrorMsg.value = "Invalid Phone Number";
    } else {
      phoneErrorVisible.value = false;
      phoneErrorMsg.value = "";
    }
    return phoneErrorVisible.value;
  }

  bool descriptionValidation(String value) {
    if (value.trim() == "") {
      if(descriptionTEController.text.isEmpty){
        descriptionErrorMsg.value = "Description is required!";
        descriptionErrorVisible.value = true;
      }
    }  else {
      descriptionErrorVisible.value = false;
      descriptionErrorMsg.value = "";
    }
    return descriptionErrorVisible.value;
  }


  Future<void> onUpdateButton() async{
    removeFocus();
    bool isAllDataValid = false;
  //  isAllDataValid =  !businessValidation(businessNameTEController.text);
    isAllDataValid = !fNameValidation(fNameTEController.text);
    isAllDataValid = !lNameValidation(lNameTEController.text) && isAllDataValid;
    isAllDataValid = !phoneValidation(phNoTEController.text) && isAllDataValid;
    isAllDataValid = !descriptionValidation(descriptionTEController.text) && isAllDataValid;
    if(isAllDataValid){
      userLoginModel.userDetailModel.profileImage=photoImage.value.path.split('/').reversed.first;
      userLoginModel.userDetailModel.coverImage=coverPhotoImage.value.path.split('/').reversed.first;
      userLoginModel.userDetailModel.firstName=fNameTEController.text;
      userLoginModel.userDetailModel.lastName=lNameTEController.text;
      userLoginModel.userDetailModel.phone=phNoTEController.text;
      userLoginModel.userDetailModel.description=descriptionTEController.text;
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        UserLoginModel userLoginModelResp = await UserService().updateProfile(userLoginModelForUpdate: userLoginModel,imgPath: photoImage.value.path,coverImagePath: coverPhotoImage.value.path);
        UserLoginModel userLoginFromSession=await userSession.getUserLoginModel();
        userLoginModelResp.token=userLoginFromSession.token;
        if (userLoginModelResp.requestErrorMessage=='Profile Updated successfully') {
          userSession.updateSessionData(userLoginModelResp);
          pd.dismissDialog();
          Get.offNamed(kVendorHomeScreen);
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(title: "Alert",
              description: userLoginModelResp.requestErrorMessage,
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
    fNameTEController.dispose();
    lNameTEController.dispose();
    phNoTEController.dispose();
    emailTEController.value.dispose();
    super.dispose();
  }
}