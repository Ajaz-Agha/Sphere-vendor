import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/email_verification_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class EmailVerificationScreen extends GetView<EmailVerificationScreenController>{
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return controller.onWillPop();

      },
      child: NotificationListener(
        onNotification: (notificationInfo){
          if(notificationInfo is UserScrollNotification){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          return true;

        },
        child: Scaffold(
          backgroundColor: AppColors.primary,
          appBar:customAppBar(image: "mail_image.png"),
          body: _getBody(heading: "Email verification",description: "We have sent code to your email: f***d@sp***e.com"),
        ),
      ),
    );
  }
  Widget _getBody({required String heading, required String description}){
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
      ),
      padding: const EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.arrow_back,color: AppColors.primary,size: 27,)),
            const SizedBox(height: 15,),
            Text(heading,style: heading1(color: AppColors.primary,fontSize: 30),),
            const SizedBox(height: 11),
            Text(description,style: heading1(color: AppColors.primary,fontSize: 16),),
            const SizedBox(height: 20,),
            otpCodeWidget(),
            const SizedBox(height: 20,),
            codeReceivedWidget(),
            const SizedBox(height: 120),
            primaryButton(
                onPressed: controller.onEmailVerify,
                buttonText: "Verify Account",textColor: AppColors.white,color: AppColors.darkPink,isMargin: false)
          ],
        ),
      ),

    );
  }

  Widget codeReceivedWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Didn’t receive code? ',style: heading1(fontSize: 12,color: AppColors.primary),),
        GestureDetector(
            onTap: (){
            },
            child: Text('Resend',style: heading1(fontSize: 12,color: AppColors.darkPink),)),
      ],
    );
  }

  Widget otpCodeWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
            height: 50,
            width: 50,
            child: Obx(
                  ()=>customTextField(
                  onChanged: controller.onTextChange,
                  keyBoardType: TextInputType.number,
                  controller: controller.firstOtpDigit,
                  enabled: controller.otp1.value
              ),
            )
        ),
        SizedBox(
            height: 50,
            width: 50,
            child: Obx(
                  ()=> customTextField(
                onChanged: controller.onTextChange,
                controller: controller.secondOtpDigit,
                enabled: controller.otp2.value,
                keyBoardType: TextInputType.number,

              ),
            )
        ),
        SizedBox(
            height: 50,
            width: 50,
            child: Obx(
                  ()=> customTextField(
                  onChanged: controller.onTextChange,
                  keyBoardType: TextInputType.number,
                  controller: controller.thirdOtpDigit,
                  enabled: controller.otp3.value
              ),
            )
        ),
        SizedBox(
            height: 50,
            width: 50,
            child: Obx(
                  ()=> customTextField(
                  onChanged: controller.onTextChange,
                  keyBoardType: TextInputType.number,
                  controller: controller.fourthOtpDigit,
                  enabled: controller.otp4.value
              ),
            )
        ),
      ],
    );
  }
}