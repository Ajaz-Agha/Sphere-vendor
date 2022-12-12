import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/initia_screen_controller.dart';
import '../../utils/app_colors.dart';

class InitialScreen extends GetView<InitialScreenController>{
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        controller.navigate();
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Center(child: Image.asset(controller.logoImage,height: 40,)),
          ),
        ),),
    );
  }

}