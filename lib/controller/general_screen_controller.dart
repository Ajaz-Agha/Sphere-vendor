import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralScreenController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String screenName='';
  Future<bool> onBackPressed() async {
    Get.back();
    return true;

  }

  @override
  void onInit() {
    screenName=Get.arguments;
    super.onInit();
  }
}