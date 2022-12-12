import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/notification_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/textStyle.dart';

class NotificationScreen extends GetView<NotificationScreenController>{
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _getBody()),
    );
  }
  Widget _getBody(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                  child: Icon(Icons.arrow_back,size: 25,color: AppColors.primary,)),
              Text('Notification',style: heading1SemiBold(color: AppColors.primary,fontSize: 20)),
              const SizedBox()
            ],
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  showNotificationWidget(name:'Candace & Brasil ',description: 'added new promo', time: '2 min ago',isBool:false),
                  showNotificationWidget(name:'Candace & Brasil ',description: 'added new promo', time: '2 min ago',isBool:true),
                  showNotificationWidget(name:'Candace & Brasil ',description: 'added new promo', time: '2 min ago',isBool:false),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 18),
                    child: Text('YESTERDAY',style: heading1(color: AppColors.textNotificationColor,fontSize: 24),),
                  ),
                  showNotificationWidget(name:'Candace & Brasil ',description: 'added new promo', time: '2 min ago',isBool:false),
                  showNotificationWidget(name:'Candace & Brasil ',description: 'added new promo', time: '2 min ago',isBool:false),
                  showNotificationWidget(name:'Candace & Brasil ',description: 'added new promo', time: '2 min ago',isBool:false),
                  showNotificationWidget(name:'Candace & Brasil ',description: 'added new promo', time: '2 min ago',isBool:false),
                  showNotificationWidget(name:'Candace & Brasil ',description: 'added new promo', time: '2 min ago',isBool:false),

                ],
              ),))
      ],
    );
  }

  Widget showNotificationWidget({required String name,required String description, required String time,required bool isBool}){
    Color backGroundColor=AppColors.lightContainerColor;
    Color textColor=AppColors.textNotificationColor;
    if(isBool){
      backGroundColor=AppColors.primary;
      textColor=AppColors.white;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        color:  backGroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10,),
        child: Row(
          children: [
            CircleAvatar(radius: 30,child: Image.asset('assets/images/logo_icon.png'),),
            const SizedBox(width: 18,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: name,
                        style: headingBold(color: textColor,fontSize: 16,fontWeight: FontWeight.w600),
                        children:  <TextSpan>[
                          TextSpan(text: description, style: bodyMediumMedium(color: textColor,fontSize: 16)),

                        ],
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Text(time,style: bodyMediumMedium(color: textColor,fontSize: 12)),
              ],
            ))
          ],
        ),
      ),
    );

  }
}