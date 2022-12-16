import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/utils/app_constants.dart';
import 'package:sphere_vendor/utils/route_management.dart';

import 'notification_service/notification_services.dart';

Future<void> backgroundHandler(RemoteMessage message) async {

}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  FirebaseMessaging.instance.getInitialMessage();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      getPages: RouteGenerator.getPages(),
      initialRoute: kInitialScreen,
    );
  }
}
