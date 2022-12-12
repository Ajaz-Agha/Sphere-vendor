import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../controller/reset_password_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class ResetPasswordScreen extends GetView<ResetPasswordScreenController>{
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        appBar:customAppBar(image: "lock_image.png"),
        body: _getBody(heading: "Reset password",description: "Please enter your email address to request a new password"),
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
            Obx(
              ()=> customTextField(
                readOnly: controller.emailReadOnly.value,
                  onChanged: controller.emailValidation,
                  controller: controller.emailTEController,
                  hintText: "Email",prefexIcon: Icon(Icons.mail_outline,size: 15,color:AppColors.lightPink,),color: AppColors.lightPink,suffixIcon: Icon(Icons.check_circle,color: AppColors.lightPink,size: 15,)),
            ),
            Obx(
                  ()=> Visibility(
                visible: controller.emailErrorVisible.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 10),
                  child: Text(controller.emailErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                ),
              ),
            ),
            SizedBox(height: 40,),
            Obx(() => Visibility(
                visible: controller.otpWidgetVisible.value,
                child: otpCodeWidget()

            )),
            const SizedBox(height: 130,),
            Obx(
                ()=> primaryButton(buttonText: controller.otpWidgetVisible.value?"Verify Email":"Send me Password",textColor: AppColors.white,color: AppColors.darkPink,isMargin: false,onPressed: (){
                  if(controller.otpWidgetVisible.value){
                    controller.onVerify();
                  }else {
                      controller.onResetEmailTap();
                    }
                  }),
            )
          ],
        ),
      ),

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