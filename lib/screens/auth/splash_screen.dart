import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/splash_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

//created by Abdul Rafay on 12-11-2022
class SplashScreen extends GetView<SplashScreenController>{
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: SafeArea(
       child: SizedBox(
         height: Get.height,
         child: Stack(
           children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Image.asset(Img.get('splash_screen_bg2.png'),height: 188,width: 200),
               Padding(
                 padding: const EdgeInsets.only(left: 20),
                 child:  Image.asset(Img.get('splash_screen_bg1.png'),height: 108,width: 120),
               ),
               Spacer(),
               Align(
                   alignment: Alignment.bottomRight,
                   child: Image.asset(Img.get('splash_screen_bg3.png'),height: 108,width: 120),),
             ],
           ),
             _getBody(),
           ],
         ),
       ),
     ),
   );
  }

  Widget _getBody(){
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to',style: heading1(color: AppColors.primary),),
              Text('Sphere Club',style: heading1SemiBold(color: AppColors.primary),),
              const SizedBox(height: 14,),
              Text(
                'The Sphere Club provides your business with a great way to generate extra traffic and encourage new customers to remain loyal to you. This effective marketing tool will help spread the word about your company or brand.',style: heading1(fontSize: 16,color: AppColors.primary),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 57,bottom: 18),
                child: primaryButton(color: AppColors.darkPink,isMargin: false,buttonText: 'Join Now',textColor: AppColors.white,onPressed: (){
                  controller.onLoginTap();
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: getSignWidget(),
              ),
            ],
          ),
        ),
      );
  }

  Widget getSignWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already a member? ',style: heading1(fontSize: 16,color: AppColors.black),),
        GestureDetector(
            onTap: (){
              controller.onLoginTap();
            },
            child: Text('Login',style: heading1(fontSize: 16,color: AppColors.lightPink),)),
      ],
    );
  }


}