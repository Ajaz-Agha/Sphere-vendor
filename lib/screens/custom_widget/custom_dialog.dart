import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sphere_vendor/screens/custom_widget/myWidgets.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/user_session_management.dart';
import '../../web_services/user_service.dart';
class CustomDialogs {
  static final CustomDialogs _instance = CustomDialogs._internal();

  CustomDialogs._internal();

  factory CustomDialogs() => _instance;

  void showMessageDialog(
      {required String title,
        required String description,
        required DialogType type,
        Function? onOkBtnPressed}) {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      context: Get.context!,
      dialogType: type,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      btnOkColor: type == DialogType.SUCCES ?  AppColors.lightPink: AppColors.darkPink,
      title: title,
      dismissOnTouchOutside: false,
      desc: description,
      customHeader: Container(
        margin: const EdgeInsets.all(6),
        child: Image.asset(Img.get('sphere_logo.png')),
      ),
      btnOkOnPress: () {
        if (onOkBtnPressed != null) {
          onOkBtnPressed();
        }
      },
    ).show();
  }

  void showDialog(
      String title, String description, DialogType type, Color btnOkColor,
      {Function? onOkBtnPressed}) {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      context: Get.context!,
      dialogType: type,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      btnOkColor: btnOkColor,
      title: title,
      dismissOnTouchOutside: false,
      desc: description,
      customHeader: Container(
          margin: const EdgeInsets.all(12.0),
          child: Image.asset(Img.get('sphere_logo.png'))),
      btnOkOnPress: () {
        if (onOkBtnPressed != null) {
          onOkBtnPressed();
        }
      },
    ).show();
  }

  void showErrorDialog(
      String title, String description, DialogType type, Color btnOkColor,
      {Function? onOkBtnPressed}) {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      context: Get.context!,
      dialogType: type,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      btnOkColor: btnOkColor,
      title: title,
      dismissOnTouchOutside: false,
      desc: description,
      customHeader: Container(
        margin: EdgeInsets.all(12.0),
        child: Image.asset("assets/images/sphere_logo.png"),),
      btnOkOnPress: () {
        if(onOkBtnPressed != null ){onOkBtnPressed();}
      },
    ).show();
  }

  void confirmationDialog(
      {required String message, required Function yesFunction}) {
    const double padding = 10.0;
    const double avatarRadius = 66.0;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.only(
                top: padding + 10,
                bottom: padding,
                left: padding + 10,
                right: padding,
              ),
              margin: const EdgeInsets.only(top: avatarRadius),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start, // To make the card compact
                children: <Widget>[
                  const Text(
                    "Confirmation",
                    //textAlign: TextAlign.center,
                    style:
                    TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    message,
                    //textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Text(
                              "NO",
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                          height: 0,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (yesFunction != null) {
                              yesFunction();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 15, top: 5, bottom: 5),
                            child: Text(
                              "YES",
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:  AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void appCloseConfirmationDialog() {
    const double padding = 10.0;
    const double avatarRadius = 0.0;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.only(
                top: padding + 8,
                bottom: padding,
                left: padding + 4,
                right: padding,
              ),
              margin: const EdgeInsets.only(top: avatarRadius),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start, // To make the card compact
                children: <Widget>[
                  const Text(
                    'Confirmation',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Are you sure you want to exit?',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 36.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child:  Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              "NO",
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:  AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                          height: 0,
                        ),
                        /* FlatButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'NO',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(kLogoBlueColor)),
                          ),
                        ),*/
                        GestureDetector(
                          onTap: () {
                            UserService().userLogOut();
                            UserSession().logOut();
                            Get.offAllNamed(kLoginScreen);
                          },
                          child:  Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 15,
                              top: 5,
                            ),
                            child: Text(
                              "YES",
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:  AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        /*FlatButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: Text(
                            'YES',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(kLogoBlueColor)),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void uploadImageDialog({required Function onSuccess}) {
    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                Get.back();
                await _permissionHandler(function: ()=>onSuccess(ImageSource.gallery),);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Image.asset(
                    "assets/images/gallery-icon.png",
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    "Gallery",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            //const SizedBox(width: 80,),
            GestureDetector(
              onTap: () async {
                Get.back();
                await _permissionHandler(function: ()=>onSuccess(ImageSource.camera),);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Image.asset(
                    "assets/images/camera-icon.png",
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 10,),
                  const Text("Camera")
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  /*void imagePickerDialog({required VoidCallback onGalleryPressed,required VoidCallback onCameraPress,}) {
    Get.dialog(
      Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text('Select File Form Camera Or Gallery'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        Get.back();
                        await _permissionHandler(function: onGalleryPressed);
                      },
                      child:Image.asset(
                        "assets/icons/gallery-icon.png",
                        width: 70,
                        height: 70,
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.back();
                        await _permissionHandler(function: onCameraPress);
                      },
                      child: Image.asset(
                        "assets/icons/camera-icon.png",
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: AppColors.darkPink.withAlpha(150),
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }*/

  Future _permissionHandler({required VoidCallback function}) async {
    PermissionStatus status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      function();
    } else if (status == PermissionStatus.permanentlyDenied) {
      CustomDialogs().showDialog(
          "Permission Denied",
          "Camera Permission is Permanently Denied\nPlease allow permission from settings and try again.",
          DialogType.ERROR,
          Colors.redAccent);
    } else {
      CustomDialogs().showDialog("Permission Denied",
          "Permission Denied", DialogType.ERROR, Colors.redAccent);
    }
  }
}