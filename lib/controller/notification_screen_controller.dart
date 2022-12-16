import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/web_services/general_service.dart';
import '../model/notification_model.dart';
import '../notification_service/notification_services.dart';

class NotificationScreenController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String text='Notification';
  Future<bool> onBackPressed() async {
      Get.back();
      return true;

  }

  RxList<NotificationModel> listOfNotifications=<NotificationModel>[].obs;

  @override
  void onInit() {
    getNotification();
    super.onInit();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        if (message != null) {
        }
      },
    );
    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);


        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
        }
      },
    );
  }
  Future<void> getNotification() async{
    dynamic response=await GeneralService().getNotification();
    if(response is List<NotificationModel>){
      listOfNotifications.value=response;
    }
  }
}