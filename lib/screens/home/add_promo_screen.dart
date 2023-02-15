import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sphere_vendor/controller/add_promo_screen_controller.dart';
import 'package:sphere_vendor/model/category_model.dart';
import 'package:sphere_vendor/screens/custom_widget/custom_dialog.dart';
import 'package:sphere_vendor/screens/custom_widget/custom_navigation_drawer.dart';
import 'package:sphere_vendor/screens/custom_widget/custom_proggress_dialog.dart';
import 'package:sphere_vendor/utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class AddPromoScreen extends GetView<AddPromoScreenController>{
  const AddPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: AppColors.white,
     appBar: AppBar(
       elevation: 0,
       backgroundColor: AppColors.white,
       automaticallyImplyLeading: false,
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           GestureDetector(
             onTap: (){
               controller.scaffoldKey.currentState!.openDrawer();
               FocusScope.of(context).requestFocus(FocusNode());
             },
             child: Image.asset("assets/images/menu_icon.png",width: 20,height: 20,),
           ),
           Text('Add Promo',style: heading1SemiBold(fontSize: 20,color: AppColors.primary),),
         SizedBox()
         // imageIcon(img: 'delete_icon.png',size: 22)

         ],
       ),
     ),
       body: NotificationListener(
           onNotification: (notificationInfo){
             if(notificationInfo is UserScrollNotification){
               FocusScopeNode currentFocus = FocusScope.of(context);
               if (!currentFocus.hasPrimaryFocus) {
                 currentFocus.unfocus();
               }
             }
             return true;

           },

           child: _getBody(context)),
       key: controller.scaffoldKey,
     drawer: const CustomNavigationDrawer(),
       );
  }
Widget _getBody(BuildContext context){
    return Stack(
        children: [
      imageIcon(img: 'splash_screen_bg2.png',size: 150),
      Align(
        alignment: Alignment.bottomRight,
        child: imageIcon(img: 'splash_screen_bg3.png',size: 100),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(()=>optionStatus(controller.activeSelected.value?AppColors.primary:AppColors.textFieldBackground, 'Active')),
                  /*Obx(()=>optionStatus(controller.hiddenSelected.value?AppColors.primary:AppColors.textFieldBackground, 'Hidden')),*/
                  Obx(()=>optionStatus(controller.draftSelected.value?AppColors.primary:AppColors.textFieldBackground, 'Draft')),
                ],
              ),
              Obx(
                    ()=> Visibility(
                  visible: controller.isStatus.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(controller.statusErrorMessage.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child: Text('Upload Photo',style: heading1SemiBold(color: AppColors.primary,fontSize: 15),)),
                  GestureDetector(
                      onTap: (){
                        controller.onImageTap();
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          decoration: BoxDecoration(
                              color: AppColors.darkPink,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text('Add',textAlign: TextAlign.center,style: bodyMediumMedium(color: AppColors.white,fontSize: 13,fontWeight: FontWeight.w500),)))
                ],
              ),
              const SizedBox(height: 10,),
              Container(
                  height: 170,
                  width: Get.width,
                  child: Obx(() =>  controller.photoImage.value.path!=''?Image.file(controller.photoImage.value,fit: BoxFit.cover):Image.asset(Img.get('upload_image.png'),fit: BoxFit.cover)),

              ),
              Obx(
                    ()=> Visibility(
                  visible: controller.isImage.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(controller.imageErrMsg.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child: Text('Upload additional photos',style: heading1SemiBold(color: AppColors.primary,fontSize: 15),)),
                  GestureDetector(
                      onTap: (){
                        controller.onMultipleImageTap();
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          decoration: BoxDecoration(
                              color: AppColors.darkPink,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text('Add',textAlign: TextAlign.center,style: bodyMediumMedium(color: AppColors.white,fontSize: 13,fontWeight: FontWeight.w500),)))
                ],
              ),
              const SizedBox(height: 10),
              Obx(()=> Container(
                  height: 70,
                  child:  controller.listOfImages.isNotEmpty?Obx(
                    ()=> ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.listOfImages.length,
                      itemBuilder: (BuildContext context,int index){
                        if (controller.listOfImages.isNotEmpty) {
                          return Stack(
                            children: [
                              Container(
                                  height: 60,width: 120,
                               padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.file(controller.listOfImages[index],fit: BoxFit.cover,),
                              ),
                              Positioned(
                                right: 2,
                                child: GestureDetector(
                                  onTap: (){
                                    controller.listOfImages.removeAt(index);
                                  },
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: AppColors.filterContainer,
                                      child: Icon(Icons.close, color: Colors.red,size: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ):SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(Img.get('border.png'),height: 60,width: 120,),
                        Image.asset(Img.get('border.png'),height: 60,width: 120,),
                        Image.asset(Img.get('border.png'),height: 60,width: 120,),
                      ],
                    ),
                  )
                ),),
              Obx(
                    ()=> Visibility(
                  visible: controller.isAdditionalImages.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(controller.additionalImagesErrMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formWidget(
                    focusNode:controller.productNameFocusNode,
                      onChanged: controller.pNameValidation,
                      title: 'Promo Name*',hint: 'promo name',textEditingController: controller.productNameTEController),
                  Obx(
                        ()=> Visibility(
                      visible: controller.productNameErrorVisible.value,
                      child: Text(controller.productNameErrorMsg.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formWidget(
                              focusNode:controller.priceFocusNode,
                            keyBoardInput: TextInputType.number,
                             // onChanged: controller.priceValidation,
                              title: 'Price',hint: '\$1000',textEditingController: controller.priceTEController),
                          Obx(
                                ()=> Visibility(
                              visible: controller.priceErrorVisible.value,
                              child: Text(controller.priceErrorMsg.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(width: 20),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              if(!controller.priceValidation(controller.priceTEController.text)) {
                                controller.chooseDiscountCategory();
                              }
                            },
                            child: Obx(()=> formWidget(
                              focusNode: controller.discountFocusNode,
                                  keyBoardInput: TextInputType.number,
                                  onChanged: controller.discountValidation,
                                  enabled: controller.isDiscount.value,
                                  title: 'Discount',hint: controller.isPercentage.value?"10%":'\$500',textEditingController: controller.discountTEController),
                            ),
                          ),
                          Obx(
                                ()=> Visibility(
                              visible: controller.discountErrorVisible.value,
                              child: Text(controller.discountErrorMsg.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                            ),
                          ),
                        ],
                      )),

                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formWidget(
                            focusNode: controller.discountStartFocusNode,
                              onChanged: controller.discountStartDateValidation,
                              title: 'Discount Start Date',hint: '2023-01-01',textEditingController: controller.discountStartTEController),
                          Obx(
                                ()=> Visibility(
                              visible: controller.discountStartErrorVisible.value,
                              child: Text(controller.discountStartErrorMsg.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(width: 20),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formWidget(
                            focusNode: controller.discountEndFocusNode,
                              onChanged: controller.discountEndDateValidation,
                              title: 'Discount Last Date',hint: '2023-01-01',textEditingController: controller.discountEndTEController),
                          Obx(
                                ()=> Visibility(
                              visible: controller.discountEndErrorVisible.value,
                              child: Text(controller.discountEndErrorMsg.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                  descriptionContainer(title: 'Description*',hint: 'Write about you',textEditingController: controller.descriptionTEController,onChanged: controller.descriptionValidation),
                  Obx(
                        ()=> Visibility(
                      visible: controller.descriptionErrorVisible.value,
                      child: Text(controller.descriptionErrorMsg.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async{
                        ProgressDialog p=ProgressDialog();
                        p.showDialog(title: 'Please wait..');
                        if(controller.markers.isNotEmpty){
                          controller.markers.clear();
                        }
                        await controller.getCurrentPosition();
                        controller.loadData();
                        controller.markers.addAll(controller.listOfMarkers);
                        if(controller.markers.isNotEmpty){
                          p.dismissDialog();
                          showBottomSheet(context);
                        }

                      },
                      child: Obx(()=>formWidget(
                          focusNode: controller.businessAddressFocusNode,
                          title: 'Promo Address*',hint: '',textEditingController: controller.businessAddressTEController.value,onChanged: controller.businessAddValidation))),
                  Obx(
                        ()=> Visibility(
                      visible: controller.businessAddressErrorVisible.value,
                      child: Text(controller.businessAddressErrorMsg.value,style: heading1(color: AppColors.requiredColor,fontSize: 12),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  titleWidget(title: '+ Add Social Links'),
                  addLinkWidget(),
                  Obx(
                      ()=> Visibility(
                        visible: controller.addLinkButtonVisible.value,
                        child: addLinkTitleWidget(title: 'Add Link')),
                  ),
                  dropDown(),
                  Obx(
                        ()=> Visibility(
                      visible: controller.isCategory.value,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(controller.categoryError.value,style: heading1(color: AppColors.primary,fontSize: 12),),
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
                            buttonText: 'Cancel',color: AppColors.textNotificationColor,textColor: AppColors.white,height: 40,fontSize: 18)),
                        Expanded(child: primaryButton(
                            onPressed: (){
                              controller.onDoneButton();
                            },
                            buttonText: 'Done',color: AppColors.darkPink,textColor: AppColors.white,height: 40,fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
}

Widget optionStatus(Color color, String title){
    return GestureDetector(
      onTap: (){
        controller.onStatusTap(title);
        color=color;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Text(title,style: bodyMediumMedium(color: color==AppColors.textFieldBackground?AppColors.primary:AppColors.white,fontSize: 13),),
      ),
    );
}

  Widget formWidget(
      {required String title,
        required String hint,
        dynamic onChanged,
        dynamic readonly,
        dynamic enabled,
        TextInputType? keyBoardInput,
        required FocusNode focusNode,
        required TextEditingController textEditingController}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget(title: title),
          const SizedBox(height: 5),
          customTextField(
            controller: textEditingController,
              onChanged: onChanged,
              focusNode: focusNode,
              keyBoardType: keyBoardInput,
              readOnly: title.contains('Discount Start Date')||title.contains('Discount Last Date')?true:false,
              enabled:title.contains('Promo Address')?false:enabled??true,
              hintText: hint,suffixIcon: 
          title.contains('Promo Address')?Icon(Icons.location_on,color: AppColors.darkPink,):
              title=='Discount'?GestureDetector(
                  onTap: (){
                   // controller.isPercentage.value=!controller.isPercentage.value;
                  },
                  child: Icon(controller.isPercentage.value?Icons.percent:Icons.attach_money,color: AppColors.darkPink,size: 17,)):
          title.contains('Discount Start Date')||title.contains('Discount Last Date')?GestureDetector(
              onTap: (){
                controller.selectDate(textEditingController);
              },
              child: Icon(Icons.calendar_month,color: AppColors.lightGrey,)):
          title.contains('Add Promo Code*')?Padding(
            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
            child: Text('Optional',style: heading1(color: AppColors.lightPink,fontSize: 15),),
          )
              :null),
        ],
      ),
    );
  }

  Widget titleWidget({required String title}){
    return Text(title,style: bodyMediumMedium(color: AppColors.primary,fontSize: 13,fontWeight: FontWeight.w500),);
  }

  Widget addLinkTitleWidget({required String title}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
            onTap: (){
              chooseSocialLink();
             /* if(controller.linkList.length<9) {
                //kdsjkssdkjksajkdjkasjdk
                controller.linkList.add(createTextField());
                if(controller.linkList.length==9){
                  controller.addLinkButtonVisible.value=false;
                }
              }*/
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                decoration: BoxDecoration(
                    color: AppColors.darkPink,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(title,textAlign: TextAlign.center,style: bodyMediumMedium(color: AppColors.white,fontSize: 13,fontWeight: FontWeight.w500),))),
      ),
    );
  }

  Widget descriptionContainer({required String title, required String hint,required TextEditingController textEditingController,required dynamic onChanged}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
        isDismissible:false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              Get.back();
              return Future.value(false);
            },
            child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Row(
                      children: [
                        imageIcon(img: 'trending_icon.png',size: 20),
                        const SizedBox(width: 4),
                        Expanded(child: Text('Confirm Promo Location',style:heading1(fontSize: 18))),
                        GestureDetector(
                            onTap: () async{
                              await Future.delayed(const Duration(milliseconds: 500));
                          Get.back();
                            },
                            child: Icon(Icons.close,color: AppColors.darkPink,size: 20,))
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: primaryButton(
                          color: AppColors.primary,
                            height: 37,
                            onPressed: () async{
                          Prediction? p = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: controller.kGoogleApiKey,
                              mode: controller.mode,
                              language: 'en',
                              strictbounds: false,
                              types: [""],
                              decoration: InputDecoration(
                                  hintText: 'Search',
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.white))),
                              components: [Component(Component.country,"pk"),Component(Component.country,"ca")]);
                         if(p!=null) {
                           controller.displayPrediction(p);
                         }
                        }, buttonText: 'Search Place',textColor: AppColors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        child: Container(
                          height: 250,
                          child:  Obx(()=>GoogleMap(
                                zoomGesturesEnabled: true, //enable Zoom in, out on map
                                onMapCreated: (GoogleMapController googleMapController){
                                 controller.googleMapController=googleMapController;
                                  if(controller.gController.isCompleted){
                                  }else {
                                    controller.gController.complete(googleMapController);
                                  }
                                },
                                mapType: MapType.normal,
                                markers: Set<Marker>.of(controller.markers),
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(controller.latLng!.latitude, controller.latLng!.longitude),
                                  zoom: 14.4746,
                                ),
                              onTap: (LatLng latLng){
                                controller.listOfMarkers.clear();
                                controller.markers.clear();
                                Marker newMarker=Marker(
                                icon:BitmapDescriptor.fromBytes((controller.markerIcon)),
                                markerId: const MarkerId('1'),
                                position: LatLng(latLng.latitude, latLng.longitude),
                                infoWindow:InfoWindow(title: controller.address.value),
                                );
                               // controller.latLng=Position(longitude: latLng.longitude, latitude: latLng.latitude, timestamp: DateTime.now(), accuracy: 1, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
                                  controller.markers.add(newMarker);
                                  controller.latitude=latLng.latitude;
                                controller.longitude=latLng.longitude;
                                controller.latLng= Position(longitude: controller.longitude, latitude: controller.latitude, timestamp: DateTime.now(), accuracy: 1, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
                                controller.getAddressFromLatLong(Position(longitude: controller.longitude, latitude: controller.latitude, timestamp: DateTime.now(), accuracy: 1, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0));

                              },
                            ),
                          ),

                          /*  child: Image.asset('assets/images/map.png',height: 300,fit: BoxFit.cover,)*/)
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: primaryButton(buttonText: 'Cancel',color: AppColors.primary,textColor: AppColors.white,height: 40,fontSize: 18,onPressed: () async{
                              await Future.delayed(const Duration(milliseconds: 500));
                              Get.back();
                            })),
                            Expanded(child: primaryButton(buttonText: 'Done',color: AppColors.darkPink,textColor: AppColors.white,height: 40,fontSize: 18,onPressed: () async{
                              await Future.delayed(const Duration(milliseconds: 500));
                              Get.back();
                              controller.onLocationUpdate();
                            })),
                          ],
                        ),
                      ),
                    ],
                  ),

                ]
            ),
          );
        }, context: context);
  }

  Widget dropDown(){
    return Obx(
          ()=> Container(
        width: Get.width,
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.textFieldBackground,
            borderRadius: BorderRadius.circular(5)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<CategoryModel>(
            isExpanded: true,
            borderRadius: BorderRadius.circular(8),
            value: controller.categoryModelDropDownInitialValue.value,
            elevation: 0,
            style: const TextStyle(color: Colors.white),
            iconEnabledColor:Colors.black,
            items: controller.items.map<DropdownMenuItem<CategoryModel>>((value) {
              return DropdownMenuItem<CategoryModel>(
                value: value,
                child: Text(value.name,style:const TextStyle(color:Colors.black),),
              );
            }).toList(),
            onChanged: (CategoryModel? value) {
              controller.onChangeDropdownForCategoryTitle(value!);

            },
          ),
        ),
      ),
    );
  }

  void chooseSocialLink(){
    showMessageDialogForSocialLink(
        type: DialogType.NO_HEADER);
  }

  void showMessageDialogForSocialLink(
      {required DialogType type,
      }) {
    AwesomeDialog(
      dismissOnBackKeyPress: true,
      context: Get.context!,
      dialogType: type,
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      btnOkColor: AppColors.darkPink,
      titleTextStyle: heading1SemiBold(color: AppColors.primary),
      dismissOnTouchOutside: true,

      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          child: Column(
            children: [
              Text('Add Social Account',style: heading1SemiBold(color: AppColors.darkPink,fontWeight: FontWeight.w500,fontSize: 20),),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () {
                     if(controller.linkList.length<9 && !controller.text.contains('facebook')) {
                       controller.linkList.add(createTextField('facebook'));
                       controller.text.add('facebook');
                       Get.back();
                       if(controller.linkList.length==9){
                         controller.addLinkButtonVisible.value=false;
                       }
                     }else{
                       CustomDialogs().showMessageDialog(title: 'Alert', description: 'facebook Link already added', type: DialogType.INFO);
                     }
                  }, child: Image.asset(Img.get('facebook_icon.png'),height: 25,),),
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () {  if(controller.linkList.length<9 && !controller.text.contains('whatsapp')) {
                    controller.linkList.add(createTextField('whatsapp'));
                    controller.text.add('whatsapp');
                    Get.back();
                    if(controller.linkList.length==9){
                      controller.addLinkButtonVisible.value=false;
                    }
                  }else{
                    CustomDialogs().showMessageDialog(title: 'Alert', description: 'Whatsapp Link already added', type: DialogType.INFO);
                  } }, child: Image.asset(Img.get('whatsapp_icon.png'),height: 25,),),
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () { if(controller.linkList.length<9 && !controller.text.contains('instagram')) {
                    controller.linkList.add(createTextField('instagram'));
                    controller.text.add('instagram');
                    Get.back();
                    if(controller.linkList.length==9){
                      controller.addLinkButtonVisible.value=false;
                    }
                  }else{
                    CustomDialogs().showMessageDialog(title: 'Alert', description: 'Instagram Link already added', type: DialogType.INFO);
                  }  }, child: Image.asset(Img.get('instagram.png'),height: 25,),),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () {
                    if(controller.linkList.length<9 && !controller.text.contains('youtube')) {
                      controller.linkList.add(createTextField('youtube'));
                      controller.text.add('youtube');
                      Get.back();
                      if(controller.linkList.length==9){
                        controller.addLinkButtonVisible.value=false;
                      }
                    }else{
                      CustomDialogs().showMessageDialog(title: 'Alert', description: 'youtube Link already added', type: DialogType.INFO);
                    }
                  }, child: Image.asset(Img.get('yotube_icon.png'),height: 25),),
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () {
                    if(controller.linkList.length<9 && !controller.text.contains('pinterest')) {
                      controller.linkList.add(createTextField('pinterest'));
                      controller.text.add('pinterest');
                      Get.back();
                      if(controller.linkList.length==9){
                        controller.addLinkButtonVisible.value=false;
                      }
                    }else{
                      CustomDialogs().showMessageDialog(title: 'Alert', description: 'pinterest Link already added', type: DialogType.INFO);
                    }
                  }, child: Image.asset(Img.get('pinterest.png'),height: 25,),),
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () {
                    if(controller.linkList.length<9 && !controller.text.contains('twitter')) {
                      controller.linkList.add(createTextField('twitter'));
                      controller.text.add('twitter');
                      Get.back();
                      if(controller.linkList.length==9){
                        controller.addLinkButtonVisible.value=false;
                      }
                    }else{
                      CustomDialogs().showMessageDialog(title: 'Alert', description: 'Twitter Link already added', type: DialogType.INFO);
                    }
                  }, child: Image.asset(Img.get('twitter_icon.png'),height: 25),),

                ],
              ),
              const SizedBox(height:3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () {
                    if(controller.linkList.length<9 && !controller.text.contains('reddit')) {
                    controller.linkList.add(createTextField('reddit'));
                    controller.text.add('reddit');
                    Get.back();
                    if(controller.linkList.length==9){
                      controller.addLinkButtonVisible.value=false;
                    }
                  }else{
                    CustomDialogs().showMessageDialog(title: 'Alert', description: 'Reddit Link already added', type: DialogType.INFO);
                  }
                    }, child: Image.asset(Img.get('reddit.png'),height: 25,),),
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () { if(controller.linkList.length<9 && !controller.text.contains('quora')) {
                    controller.linkList.add(createTextField('quora'));
                    controller.text.add('quora');
                    Get.back();
                    if(controller.linkList.length==9){
                      controller.addLinkButtonVisible.value=false;
                    }
                  }else{
                    CustomDialogs().showMessageDialog(title: 'Alert', description: 'Quora Link already added', type: DialogType.INFO);
                  }   }, child: Image.asset(Img.get('quora.png'),height: 25,),),
                  MaterialButton(
                    shape: const CircleBorder(),
                    height: 35,
                    color: AppColors.lightDividerColor,
                    onPressed: () {
                    if(controller.linkList.length<9 && !controller.text.contains('linkedin')) {
                      controller.linkList.add(createTextField('linkedin'));
                      controller.text.add('linkedin');
                      Get.back();
                      if(controller.linkList.length==9){
                        controller.addLinkButtonVisible.value=false;
                      }
                    }else{
                      CustomDialogs().showMessageDialog(title: 'Alert', description: 'LinkedIn Link already added', type: DialogType.INFO);
                    }
                  }, child: Image.asset(Img.get('linkedin_icon.png'),height: 25,),),
                ],
              ),
              const SizedBox(height:10),
            ],
          ),
        ),
      ),
    ).show();
  }



  Widget addLinkWidget(){
    return Obx(
      ()=> Column(
        children: [
          for(int index=0;index<controller.linkList.length;index++)
          GestureDetector(
              onTap: (){
                controller.linkList.removeAt(index);
                controller.text.removeAt(index);
                controller.linkListTEController.removeAt(index);
              },
              child: controller.linkList[index])
        ],
      ),
    );
  }

  Widget createTextField(String text) {
    TextEditingController linkTypeController = TextEditingController();
    controller.linkListTEController.add(linkTypeController);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                color: AppColors.filterContainer,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(2),
              child: const Icon(Icons.close,color: Colors.red,size: 15,)),
          SizedBox(height: 2),
          customTextField(
              controller: linkTypeController,
            hintText: 'https://wwww.$text.abcd',
            suffixIcon:
            Padding(padding: const EdgeInsets.only(left: 10,top: 12,bottom: 12),child: Image.asset(Img.get(
                text=='facebook'?'facebook_icon.png':
                text=='whatsapp'?'whatsapp_icon.png' :
                text=='instagram'?'instagram.png' :
                text=='youtube'?'yotube_icon.png' :
                text=='pinterest'?'pinterest.png' :
                text=='twitter'?'twitter_icon.png' :
                text=='reddit'?'reddit.png' :
                text=='quora'?'quora.png' : 'linkedin_icon.png'
            )),)),
        ],
      ),
    );
  }




}