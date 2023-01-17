import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/controller/general_screen_controller.dart';

import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class GeneralScreen extends GetView<GeneralScreenController>{
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>controller.onBackPressed(),
      child: Scaffold(
        body: SafeArea(child: _getBody()),
      ),
    );
  }
  Widget _getBody(){
    return Stack(
      children: [
        imageIcon(img: 'splash_screen_bg2.png',size: 150),
        Align(
          alignment: Alignment.bottomRight,
          child: imageIcon(img: 'splash_screen_bg3.png',size: 100),
        ),
        Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: (){
                          controller.onBackPressed();
                        },
                        child: Icon(Icons.arrow_back,size: 25,color: AppColors.primary,)),
                    Text(controller.screenName,style: heading1SemiBold(color: AppColors.primary,fontSize: 20)),
                    const SizedBox()
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: controller.screenName=='Terms of Service'?SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text('Read each offer carefully for any conditions, restrictions and exclusions.',style: headingBold(color: AppColors.darkPink),),
                        const SizedBox(height: 13),
                        Text('When an offer has additional stated conditions, those conditions supersede the Terms of Use.',style: heading1(color: AppColors.black,fontSize: 15),),
                        const SizedBox(height: 8),
                        Text('Present your Sphere Club Card in person or on your phone to a participating merchant at the time of payment.',style: heading1(color: AppColors.black,fontSize: 15)),
                        const SizedBox(height: 8),
                        Text('The merchant will verify the club card. You will be asked to show your phone when redeeming through the APP.',style: heading1(color: AppColors.black,fontSize: 15)),
                        const SizedBox(height: 8),
                        Text('Discounts exclude tax, tip and/or alcohol unless expressly stated otherwise.',style: heading1(color: AppColors.black,fontSize: 15)),
                        const SizedBox(height: 8),
                        Text('Club cards automatically renew January 1 of the following year.',style: heading1(color: AppColors.black,fontSize: 15)),
                        const SizedBox(height: 8),
                        Text('Offers are not valid with other discounts and are non-transferable.',style: heading1(color: AppColors.black,fontSize: 15),),
                        const SizedBox(height: 8),
                        Text('One Sphere Club Card, or mobile device offer is limited 1 per household.',style: heading1(color: AppColors.black,fontSize: 15),),
                        const SizedBox(height: 8),
                        Text('Offers are subject to the maximum dollar value stated. The least expensive item(s), up to the maximum value stated, will be deducted from your bill, or you will receive a percentage off the designated item(s), up to the maximum value stated.',style: heading1(color: AppColors.black,fontSize: 15),),
                        const SizedBox(height: 8),
                        Text('For restaurants offering a complimentary “menu item” when a second is purchased, a “menu item” is a main course or entrée item.',style: heading1(color: AppColors.black,fontSize: 15),),
                        const SizedBox(height: 8),
                        Text('Please check with the Vendor regarding other regional or local holidays that might be excluded.',style: heading1(color: AppColors.black,fontSize: 15),),
                        const SizedBox(height: 8),
                        Text('Sphere Club Cards are: non-refundable, non-transferable and have NO CASH VALUE.',style: heading1(color: AppColors.black,fontSize: 15),),
                        const SizedBox(height: 10),
                        Text('Feel Free to reach us at:',textAlign:TextAlign.center,style: heading1(color: AppColors.primary,fontSize: 20),),
                        const SizedBox(height: 8),
                        Text('join@sphereclubcard.ca',textAlign:TextAlign.center,style: heading1(color: AppColors.darkPink,fontSize: 18),),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ):SizedBox(),
              )
            ],
          ),
              ],
    );
  }

}