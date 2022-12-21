import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/notification_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class NotificationScreen extends GetView<NotificationScreenController>{
  const NotificationScreen({super.key});

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
        Obx(
            ()=> Column(
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
                    Text(controller.text,style: heading1SemiBold(color: AppColors.primary,fontSize: 20)),
                    const SizedBox()
                  ],
                ),
              ),
              controller.listOfNotifications.isNotEmpty?
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        for(int i=0;i<controller.listOfNotifications.length;i++)
                        showNotificationWidget(imageUrl:controller.listOfNotifications[i].userDetailModel.profileImageUrl,name:controller.listOfNotifications[i].userDetailModel.firstName!=''?controller.listOfNotifications[i].userDetailModel.firstName:controller.listOfNotifications[i].userDetailModel.uAccEmail,description: controller.listOfNotifications[i].body, time: controller.listOfNotifications[i].createdAt),
                      ],
                    ),
                  )):Center(child: showEmptyListMessage(message: 'No Notification Found'),)
            ],
          ),
        ),
      ],
    );
  }

  Widget showNotificationWidget({required String name,required String description, required String time,required String imageUrl}){
    Color backGroundColor=Colors.transparent;
    Color textColor=AppColors.textNotificationColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        color:  backGroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10,),
        child: Row(
          children: [
            CircleAvatar(radius: 30,backgroundImage: imageUrl!=''?NetworkImage(imageUrl):null,backgroundColor: AppColors.lightGrey,),
            const SizedBox(width: 18,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description, style: bodyMediumMedium(color: textColor,fontSize: 16)),
                    const SizedBox(height: 6,),
                    Text(time.split('T')[1].split('.')[0],style: bodyMediumMedium(color: textColor,fontSize: 12)),
              ],
            ))
          ],
        ),
      ),
    );

  }
}