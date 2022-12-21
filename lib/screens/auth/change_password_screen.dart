import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/change_password_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class ChangePasswordScreen extends GetView<ChangePasswordScreenController>{
  const ChangePasswordScreen({super.key});

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
            appBar:customAppBar(image: "lock_image.png"),
            body: _getBody(heading: "Change Password",description: "Please enter your new password"),
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
          children: [
            const SizedBox(height: 20,),
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
                onChanged: controller.passwordValidation,
                controller: controller.passwordController,
                isPassword: controller.obscured.value,showpassword:controller.obscured.value,hintText: "Password",prefexIcon: Icon(Icons.lock_open,size: 15,color: AppColors.black,),color: AppColors.lightPink,
                suffixIcon: GestureDetector(
                  onTap: controller.toggleObscured,
                  child: Icon(
                    controller.obscured.value
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    size: 15,
                    color: AppColors.lightPink,
                  ),
                ),),
            ),
            Obx(
                  ()=> Visibility(
                visible: controller.passwordErrorMsgVisibility.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 10),
                  child: Text(controller.passwordTFErrorMsg.value,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Obx(
                  ()=> customTextField(
                onChanged: controller.confirmPasswordValidation,
                controller: controller.confirmPasswordController,
                isPassword: controller.obscured.value,showpassword:controller.obscured.value,hintText: "Confirm Password",prefexIcon: Icon(Icons.lock_open,size: 15,color: AppColors.black,),color: AppColors.lightPink, suffixIcon: GestureDetector(
                onTap: controller.toggleObscured,
                child: Icon(
                  controller.obscured.value
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  size: 15,
                  color: AppColors.lightPink,
                ),
              ),),
            ),
            Obx(
                  ()=> Visibility(
                visible: controller.confirmPasswordErrorMsgVisibility.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 20),
                  child: Text(controller.confirmPasswordTFErrorMsg.value,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                ),
              ),
            ),
            const SizedBox(height: 50),
            primaryButton(
                onPressed: controller.changePasswordButtonPressed,
                buttonText: 'Change Password',isMargin: false,color: AppColors.darkPink,textColor: AppColors.white),
            const SizedBox(height: 10,)
          ],

        ),
      ),
    );
  }

  Widget socialMediaIconWidget({onPressed, required String image}) {
    return Container(
      height: 36,
      width: 59,
      decoration: BoxDecoration(
        color:AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(8),
        shape: BoxShape.rectangle,
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: imageIcon(img: image),
        ),
      ),
    );
  }

}