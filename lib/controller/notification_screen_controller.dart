import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreenController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Future<bool> onBackPressed() async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      Get.back();
      return Future.value(false);
    } else {
      Get.back();
      return true;

    }

  }
}