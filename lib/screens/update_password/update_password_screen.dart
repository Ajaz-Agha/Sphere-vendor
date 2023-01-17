import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/update_password_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class UpdatePasswordScreen extends GetView<UpdatePasswordScreenController>{
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _getBody()),
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
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back,size: 25,color: AppColors.primary,)),
                  Text('Update Password',style: heading1SemiBold(color: AppColors.primary,fontSize: 20)),
                  const SizedBox()
                ],
              ),
            ),
            Expanded(
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        Obx(
                              ()=> customTextField(
                            onChanged: controller.oldPasswordValidation,
                            controller: controller.oldPasswordController,
                            isPassword: controller.obscured.value,showpassword:controller.obscured.value,hintText: "Old Password",prefexIcon: Icon(Icons.lock_open,size: 15,color: AppColors.black,),color: AppColors.lightPink,
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
                            visible: controller.oldPasswordErrorMsgVisibility.value,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3,bottom: 10),
                              child: Text(controller.oldPasswordTFErrorMsg.value,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                ))
          ],
        ),
      ],
    );
  }

}