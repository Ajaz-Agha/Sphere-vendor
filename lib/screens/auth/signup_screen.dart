import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/signup_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class SignupScreen extends GetView<SignUpScreenController>{
  const SignupScreen({super.key});

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
            backgroundColor: AppColors.white,
            body: signUpWidget()
        ),
      ),
    );
  }

  Widget signUpWidget(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child:  Obx(()=>customTextField(
                  controller: controller.businessController,
                    onChanged: controller.businessValidation,
                    hintText: "Business name",prefexIcon: Icon(Icons.person_pin_rounded,size: 15,color: AppColors.black,),color: AppColors.lightPink,suffixIcon: Icon(Icons.check_circle,color: controller.businessErrorMsgVisibility.value?AppColors.lightPink:AppColors.darkPink,size: 15,)),
              ),),
            Obx(
                  ()=> Visibility(
                visible: controller.businessErrorMsgVisibility.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(controller.businessTFErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child:  Obx(()=>customTextField(
                    onChanged: controller.emailValidation,
                    controller: controller.emailController,
                    hintText: "Email",prefexIcon: Icon(Icons.mail_outline,size: 15,color: AppColors.black,),color: AppColors.lightPink,suffixIcon: Icon(Icons.check_circle,color: controller.emailErrorMsgVisibility.value?AppColors.lightPink:AppColors.darkPink,size: 15,)),
              ),),
            Obx(
                  ()=> Visibility(
                visible: controller.emailErrorMsgVisibility.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 10),
                  child: Text(controller.emailTFErrorMsg.value,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                ),
              ),
            ),
            const SizedBox(height: 10,),
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
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                socialMediaIconWidget(image: "facebook_icon.png",onPressed: (){}),
                socialMediaIconWidget(image: "google_icon.png",onPressed: (){}),
                socialMediaIconWidget(image: "apple_icon.png",onPressed: (){}),
              ],
            ),
            const SizedBox(height: 50),
            primaryButton(
                onPressed: controller.registerButtonPressed,
                buttonText: 'Sign Up',isMargin: false,color: AppColors.darkPink,textColor: AppColors.white),
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