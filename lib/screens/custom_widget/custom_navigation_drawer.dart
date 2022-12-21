import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/screens/custom_widget/textStyle.dart';
import '../../controller/custom_navigation_drawer.dart';
import '../../utils/app_colors.dart';
import 'myWidgets.dart';

class CustomNavigationDrawer extends GetView<CustomNavigationDrawerController>{
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          ),
          width: Get.width/1.3,
          elevation: 5,
          child: Stack(
              children: [
                imageIcon(img: 'splash_screen_bg2.png',size: 150),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                   Align(
                     alignment: Alignment.topRight,
                     child: Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                            child: const Icon(Icons.close)),
                      ),
                   ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Obx(
                                  ()=>
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: controller.userLoginModel.value.userDetailModel.profileImageUrl!=''?Image.network(controller.userLoginModel.value.userDetailModel.profileImageUrl,fit: BoxFit.cover,
                                    errorBuilder: (context,x,y)=>Container(
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                        color: const Color(0x30A0A0A0),
                                        child: const Icon(Icons.error,color: Colors.red,)
                                    )
                                ):imageIcon(img: 'user_image.png'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(()=> Text(controller.userLoginModel.value.userDetailModel.uAccEmail,style: heading1(color: AppColors.primary,fontSize: 14),)),
                                Obx(()=>Text(controller.userLoginModel.value.userDetailModel.businessName,style: heading1(color: AppColors.primary,fontSize: 20,fontWeight: FontWeight.w300),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height:24),
                            _getDrawerNavItem(
                              icon: 'user_icon.png',
                              title: "User Profile",),
                            _getDrawerNavItem(
                              icon: 'promotion_icon.png',
                              title: "My Promotion",
                            ),
                            _getDrawerNavItem(
                              icon: 'notification_icon.png',
                              title: "Notification",
                            ),
                            _getDrawerNavItem(
                              icon: 'feedback_icon.png',
                              title: "Help & Feedback",
                            ),
                            _getDrawerNavItem(
                              icon: 'privacy_icon.png',
                              title: "Privacy Policy",
                            ),
                            _getDrawerNavItem(
                              icon: 'service_icon.png',
                              title: "Terms of Service",
                            ),
                            _getDrawerNavItem(
                              icon: 'setting_icon.png',
                              title: "Settings",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => controller.onDrawerItemClick(title: 'LOGOUT'),
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                            height: 50,
                            width: Get.width/2,
                           decoration: BoxDecoration(
                             color: AppColors.darkPink,
                             borderRadius: BorderRadius.circular(10)
                           ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Expanded(child: Center(child: Text('Logout',style: headingBold(color: AppColors.white),)))
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ]
          )
      ),
    );
  }
  Widget _getDrawerNavItem({required String title,required String icon}) {
    return Obx(
      ()=>Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 6),
        decoration:  BoxDecoration(
          color: controller.isTap.value?AppColors.primary:AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: () => controller.onDrawerItemClick(title: title),
          child: Column(
            children: [
              Row(
                children: [
                  imageIcon(img: icon,color: controller.isTap.value?AppColors.white:AppColors.primary),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: heading1(color: controller.isTap.value?AppColors.white:AppColors.primary,fontWeight: FontWeight.w300,fontSize: 20),
                    ),
                  ),
                  title=='My Promotion'?Obx(()=> Icon(controller.isPromotionOption.value?Icons.arrow_drop_up_rounded:Icons.arrow_drop_down_outlined,color: AppColors.primary,)):const SizedBox()
                ],
              ),
              Obx(
                  ()=> Visibility(
                    visible: controller.isPromotionOption.value && title=='My Promotion',
                    child: Column(
                  children: [
                    _getDrawerNavItem(
                      icon: 'active_icon.png',
                      title: "Active",),
                    _getDrawerNavItem(
                      icon: 'inactive.png',
                      title: "Hidden",
                    ),
                    _getDrawerNavItem(
                      icon: 'draft_icon.png',
                      title: "Draft",
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}