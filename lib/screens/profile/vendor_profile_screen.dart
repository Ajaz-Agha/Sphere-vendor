import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/utils/app_constants.dart';
import '../../controller/vendor_profile_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class VendorProfileScreen extends GetView<VendorProfileScreenController>{
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return controller.onBackPressed();
      },
      child: Scaffold(
        key: controller.scaffoldKey,
        body: SafeArea(child: _getBody(context)),
      ),
    );
  }
Widget _getBody(BuildContext context){
    return Column(
      children: [
        SafeArea(
          child: Stack(
              children: [
                Obx(
                  ()=> Container(
                    height: 180,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: controller.coverPhotoImage.value.path==""?AssetImage(Img.get('empty_record.png')):FileImage(controller.coverPhotoImage.value) as ImageProvider,fit: BoxFit.cover),
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.offNamed(kVendorHomeScreen);
                          },
                          child: iconWidget(icon: Icons.arrow_back)
                        ),
                        Text('Profile',style: heading1SemiBold(fontSize: 20,color: AppColors.primary),),
                        GestureDetector(
                          onTap: (){
                            controller.onUploadCoverImage();
                          },
                          child: Container(
                              height: 30,
                             width: 100,
                              decoration: BoxDecoration(
                                  color: AppColors.darkPink,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  imageIcon(img: 'cover_edit.png',size: 15),
                                  Expanded(child: Center(child: Text('Edit Cover',style: headingBold(color: AppColors.white,fontSize: 12),)))
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 130),
                      padding: const EdgeInsets.all(3),
                      width: 100,
                      height: 100,
                      child: Stack(
                        children:[
                          Obx(()=>CircleAvatar(
                            maxRadius: 60,
                            backgroundColor: AppColors.emptyProfile,
                            backgroundImage: controller.photoImage.value.path!=''?FileImage(controller.photoImage.value):null,
                            child:
                            controller.photoImage.value.path==''?
                            Center(child:Text('DP',style: heading1SemiBold(color: AppColors.lightGrey,fontSize: 50),)):null,
                          ),
                          ),
                          Align(alignment: Alignment.bottomRight,child: GestureDetector(
                              onTap: () {
                                controller.onUploadImage();
                              },
                              child: imageIcon(img: 'profile_camera.png')),),

                        ],
                      ),
                    ),
                  ],),
              ]
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                  ()=> formWidget(
                    readOnly: true,
                        title: 'Business Name*',hint: controller.userLoginModelFromSession.value.userDetailModel.businessName,textEditingController: controller.businessNameTEController.value),
                  ),
                 /* Obx(
                        ()=> Visibility(
                      visible: controller.businessNameErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.businessNameErrorMsg.value,textAlign:TextAlign.start,style: heading1(color: AppColors.primary,fontSize: 12),),
                      ),
                    ),
                  ),*/
                  formWidget(
                      onChanged: controller.fNameValidation,
                      title: 'First Name*',hint: 'Name',textEditingController: controller.fNameTEController),
                  Obx(
                        ()=> Visibility(
                      visible: controller.fNameErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.fNameErrorMsg.value,textAlign:TextAlign.start,style: heading1(color: AppColors.primary,fontSize: 12),),
                      ),
                    ),
                  ),
                  formWidget(
                      onChanged: controller.lNameValidation,
                      title: 'Last Name*',hint: 'Last Name',textEditingController: controller.lNameTEController),
                  Obx(
                        ()=> Visibility(
                      visible: controller.lNameErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.lNameErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                      ),
                    ),
                  ),
                  Obx(()=> formWidget(readOnly:true,title: 'Email*',hint: controller.userLoginModelFromSession.value.userDetailModel.uAccEmail,textEditingController: controller.emailTEController.value)),
                  formWidget(
                      onChanged: controller.phoneValidation,
                      keyBoardInput: TextInputType.phone,
                      title: 'Phone Number*',hint: 'Phone Number',textEditingController: controller.phNoTEController),
                  Obx(
                        ()=> Visibility(
                      visible: controller.phoneErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.phoneErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: (){
                        showBottomSheet(context);
                      },

                      child: formWidget(title: 'Business Address*',hint: 'Luxury Chair',textEditingController: controller.businessAddTEController)),
                  descriptionContainer(title: 'Description*',hint: 'Write about you',textEditingController: controller.descriptionTEController,onChanged: controller.descriptionValidation),
                  Obx(
                        ()=> Visibility(
                      visible: controller.descriptionErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.descriptionErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60,bottom: 10),
                    child: Row(
                      children: [
                        Expanded(child: primaryButton(
                            onPressed: (){
                              Get.back();
                            },
                            buttonText: 'Cancel',color: AppColors.primary,textColor: AppColors.white,height: 40,fontSize: 18)),
                        Expanded(child: primaryButton(
                            onPressed: (){
                              controller.onUpdateButton();
                            },
                            buttonText: 'Done',color: AppColors.darkPink,textColor: AppColors.white,height: 40,fontSize: 18)),
                      ],
                    ),
                  )
                  ],
        ),))
      ],
    );
}
Widget formWidget(
    {required String title,
      required String hint,
      dynamic onChanged,
      bool readOnly=false,
      required TextEditingController textEditingController,TextInputType? keyBoardInput}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget(title: title),
          const SizedBox(height: 5),
          customTextField(
            readOnly: readOnly,
            keyBoardType: keyBoardInput,
            onChanged: onChanged,
              controller: textEditingController,
              enabled:title.contains('Business Address')?false:true,
              hintText: hint,suffixIcon: title.contains('Business Address')?Icon(Icons.location_on,color: AppColors.darkPink,):null),
        ],
      ),
    );
  }

  Widget titleWidget({required String title}){
    return Text(title,style: bodyMediumMedium(color: AppColors.primary,fontSize: 13,fontWeight: FontWeight.w500),);
  }

  Widget descriptionContainer({required String title, required String hint,required TextEditingController textEditingController,required dynamic onChanged}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget(title: title),
          const SizedBox(height: 5),
          Container(
            height: 120,
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.textFieldBackground,
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(8),
            child:  TextField(
              controller: textEditingController,
              onChanged: (value){
                onChanged(value);
              },
              maxLines: 5,
              decoration: InputDecoration(
              //contentPadding: const EdgeInsets.only(left: 15, right: 15),
              focusColor: AppColors.darkPink,
                border: InputBorder.none,
              filled: true,
              counterText: "",
              prefixIconColor: AppColors.black,
              hintStyle: bodyMediumMedium(color: AppColors.secondary,fontSize: 18),
              hintText: 'description....',
              fillColor: AppColors.textFieldBackground,
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconWidget({String? image="", IconData? icon}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child:
          image!=""?
          imageIcon(img: image!,size: 16):Icon(icon,color: AppColors.darkPink,size: 16,),
        ),

      ),
    );
  }

  Future<dynamic> showBottomSheet(BuildContext context){
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    children: [
                      imageIcon(img: 'trending_icon.png',size: 20),
                      const SizedBox(width: 4),
                      Expanded(child: Text('User My Location',style:heading1(fontSize: 18))),
                      GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Icon(Icons.close,color: AppColors.darkPink,size: 20,))
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        child: Stack(
                          children: [
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(image: AssetImage('assets/images/map.png'),fit: BoxFit.cover)
                              ),

                              /*  child: Image.asset('assets/images/map.png',height: 300,fit: BoxFit.cover,)*/),
                            Positioned(
                                top: 20,
                                right: 10,
                                left: 10,
                                child: Icon(Icons.location_on,size: 60,color: AppColors.darkPink,)),
                          ],)
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(child: primaryButton(buttonText: 'Cancel',color: AppColors.primary,textColor: AppColors.white,height: 40,fontSize: 18)),
                          Expanded(child: primaryButton(buttonText: 'Done',color: AppColors.darkPink,textColor: AppColors.white,height: 40,fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),

              ]
          );
        }, context: context);
  }
}