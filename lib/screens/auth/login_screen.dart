import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/screens/auth/signup_screen.dart';
import '../../controller/login_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';


class LoginScreen extends GetView<LoginScreenController>{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        appBar:appBarWidget(),
        body: _getBody()
    );
  }

  Widget _getBody(){
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10,right: 20,left: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          TabBar(
            controller: controller.tabController,
            labelColor: AppColors.darkPink,
            unselectedLabelColor: Colors.black,
            indicatorColor: AppColors.darkPink,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(child: Text('    Sign In    ',style: heading1SemiBold(fontSize: 20))),
              Tab(child: Text('    Sign Up    ',style: heading1SemiBold(fontSize: 20))),
            ],
          ),
          Expanded(
            child: Container(
                height: 400,
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.lightDividerColor,width: 0.5))),
                child: TabBarView(
                    controller: controller.tabController,
                    children: <Widget>[
                      loginWidget(),
                      const SignupScreen(),
                    ])
            ),
          )
        ]),
      ),
    );
  }

  Widget loginWidget(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child:  customTextField(
                  onChanged: controller.emailValidation,
                  controller: controller.emailTEController,
                  hintText: "Email",prefexIcon: Icon(Icons.mail_outline,size: 15,color: AppColors.black,),color: AppColors.lightPink,suffixIcon: Icon(Icons.check_circle,color: AppColors.lightPink,size: 15,)),),
            Obx(
                  ()=> Visibility(
                visible: controller.emailErrorVisible.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 10),
                  child: Text(controller.emailErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Obx(
                  ()=> customTextField(
                onChanged: controller.passwordValidation,
                controller: controller.passwordTEController,
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
                visible: controller.passwordErrorVisible.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3,bottom: 10),
                  child: Text(controller.passwordErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                ),
              ),
            ),           Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 20),
              child: Row(
                children: [
                  Icon(Icons.check_box_sharp,color: AppColors.lightPink,size: 10,),
                  const SizedBox(width: 3),
                  Expanded(child: Text('Remember me',style: heading1(color: AppColors.primary,fontSize: 12),)),
                  GestureDetector(
                      onTap: (){
                        controller.onRestPasswordTap();
                      },
                      child: Text('Forget Password?',style: heading1(color: AppColors.primary,fontSize: 12),)),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                socialMediaIconWidget(image: "facebook_icon.png",onPressed: (){
                }),
                socialMediaIconWidget(image: "google_icon.png",onPressed: (){
                  controller.onGoogleSignIn();
                }),
                socialMediaIconWidget(image: "apple_icon.png",onPressed: (){}),
              ],
            ),
            const SizedBox(height: 30),
            primaryButton(onPressed: (){
              controller.onSubmitProcess();
            },buttonText: 'Sign In',isMargin: false,color: AppColors.darkPink,textColor: AppColors.white,),
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

  PreferredSize appBarWidget(){
    return PreferredSize(
        preferredSize:const Size.fromHeight(220),
        child: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(()=>Text(controller.selectedIndex.value!=0?"Create a new":"Welcome",style: bodyMediumMedium(color: AppColors.white,fontSize: 30),)),
                          Obx(()=>Text(controller.selectedIndex.value!=0?"account":"back",style: heading1SemiBold(color: AppColors.white,fontSize: 30),)),
                          const SizedBox(height: 14,),
                          Expanded(child: Text(  controller.tabController.index!=0?'Lorem ipsum dolor sit amet, conse ctetuer adipis cing elit, asdjhsadj hasd ashdkja shdasjhdaslkdahs':'Lorem ipsum dolor sit amet, conse ctetuer adipis cing elit, asdjhsadj hasd ashdkja shdasjhdaslkdahs',style:heading1(color: AppColors.white,fontSize: 14)))
                        ],
                      ),
                    )
                ),
              ],
            )
        ));
  }

}