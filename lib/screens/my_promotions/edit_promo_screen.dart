import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sphere_vendor/model/category_model.dart';
import 'package:sphere_vendor/model/link_model.dart';
import 'package:sphere_vendor/screens/custom_widget/custom_navigation_drawer.dart';
import 'package:sphere_vendor/utils/app_colors.dart';
import 'package:sphere_vendor/utils/app_constants.dart';
import '../../controller/edit_promo_screen_controller.dart';
import '../custom_widget/custom_proggress_dialog.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class EditPromoScreen extends GetView<EditPromoScreenController>{
  const EditPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
    return controller.onWillPop();

    },
      child: Scaffold(
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
              Text('Edit Promo',style: heading1SemiBold(fontSize: 20,color: AppColors.primary),),
              GestureDetector(
                  onTap: (){
                    controller.onDeletePromo();
                  },
                  child: imageIcon(img: 'delete_icon.png',size: 22))

            ],
          ),
        ),
        body: _getBody(context),
        key: controller.scaffoldKey,
        drawer: const CustomNavigationDrawer(),
      ),
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
                  SizedBox(
                    height: 170,
                    width: Get.width,
                    child: Obx(() =>  controller.photoImage.value.path!=''?Image.file(controller.photoImage.value,fit: BoxFit.cover):Image.network(controller.getPromoModel.promoImageUrl, errorBuilder: (context,x,y)=>Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        color: const Color(0x30A0A0A0),
                        child: const Icon(Icons.error,color: Colors.red,)
                    ),fit: BoxFit.cover)),

                  ),
                  Obx(
                        ()=> Visibility(
                      visible: controller.isImage.value,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(controller.imageErrMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
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
                  Obx(()=> SizedBox(
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
                      ):ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.getPromoModel.promoImagesModel.length,
                        itemBuilder: (BuildContext context,int index){
                          if (controller.getPromoModel.promoImagesModel.isNotEmpty) {
                            return Container(
                              height: 60,width: 120,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.network(controller.getPromoModel.promoImagesModel[index].imageUrl, errorBuilder: (context,x,y)=>Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  color: const Color(0x30A0A0A0),
                                  child: const Icon(Icons.error,color: Colors.red,)
                              ),fit: BoxFit.cover,),
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
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
                          onChanged: controller.pNameValidation,
                          title: 'Promo Name*',hint: 'promo name',textEditingController: controller.productNameTEController),
                      Obx(
                            ()=> Visibility(
                          visible: controller.productNameErrorVisible.value,
                          child: Text(controller.productNameErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              formWidget(
                                  keyBoardInput: TextInputType.number,
                                  onChanged: controller.priceValidation,
                                  title: 'Price*',hint: '\$1000',textEditingController: controller.priceTEController),
                              Obx(
                                    ()=> Visibility(
                                  visible: controller.priceErrorVisible.value,
                                  child: Text(controller.priceErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
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
                                    //focusNode: controller.discountFocusNode,
                                    keyBoardInput: TextInputType.number,
                                    onChanged: controller.discountValidation,
                                    enabled: controller.isDiscount.value,
                                    title: 'Discount',hint: controller.isPercentage.value?"10%":'\$500',textEditingController: controller.discountTEController),
                                ),
                              ),
                              Obx(
                                    ()=> Visibility(
                                  visible: controller.discountErrorVisible.value,
                                  child: Text(controller.discountErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
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
                                  onChanged: controller.discountStartDateValidation,
                                  title: 'Discount Start Date',hint: 'yyyy-mm-dd',textEditingController: controller.discountStartTEController),
                              Obx(
                                    ()=> Visibility(
                                  visible: controller.discountStartErrorVisible.value,
                                  child: Text(controller.discountStartErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                                ),
                              ),
                            ],
                          )),
                          const SizedBox(width: 20),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              formWidget(
                                  onChanged: controller.discountEndDateValidation,
                                  title: 'Discount Last Date',hint: 'yyyy-mm-dd',textEditingController: controller.discountEndTEController),
                              Obx(
                                    ()=> Visibility(
                                  visible: controller.discountEndErrorVisible.value,
                                  child: Text(controller.discountEndErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
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
                          child: Text(controller.descriptionErrorMsg.value,style: heading1(color: AppColors.primary,fontSize: 12),),
                        ),
                      ),
                      GestureDetector(
                          onTap: () async{
                            ProgressDialog p=ProgressDialog();
                            p.showDialog(title: 'Please wait..');
                            await controller.getCurrentPosition();
                            controller.loadData();
                            controller.markers.addAll(controller.listOfMarkers);
                            if(controller.markers.isNotEmpty){
                              p.dismissDialog();
                              showBottomSheet(context);
                            }
                          },
                          child: formWidget(title: 'Promo Address*',hint: 'address',textEditingController: controller.businessAddressTEController)),
                      Visibility(
                          visible:  controller.getPromoModel.socialLinks.isNotEmpty,
                          child: titleWidget(title: '+ Add Social Links*')),
                      addLinkWidget(),
                      controller.getPromoModel.socialLinks.isNotEmpty?Obx(
                            ()=> Visibility(
                            visible: controller.addLinkButtonVisible.value,
                            child: addLinkTitleWidget(title: 'Add Link')),
                      ):const SizedBox(),
                      titleWidget(title: 'Add Category*'),
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
                     // addTextWidget(),
                      Padding(
                        padding: const EdgeInsets.only(top: 60,bottom: 10),
                        child: Row(
                          children: [
                            Expanded(child: primaryButton(
                                onPressed: (){
                                  Get.offAllNamed(kVendorHomeScreen);
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


  Widget formWidget(
      {required String title,
        required String hint,
        dynamic onChanged,
        dynamic enabled,
        TextInputType? keyBoardInput,
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
              keyBoardType: keyBoardInput,
              readOnly: title.contains('Discount Start Date')||title.contains('Discount Last Date')?true:false,
              enabled:title.contains('Promo Address')?false:enabled??true,
              hintText: hint,suffixIcon:
          title.contains('Promo Address')?Icon(Icons.location_on,color: AppColors.darkPink,):title=='Discount'?GestureDetector(
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
                for(int i=0;i<controller.getPromoModel.socialLinks.length;i++){
                  controller.linkList.add(createTextField(controller.getPromoModel.socialLinks[i]));
                  controller.addLinkButtonVisible.value=false;
              }
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
                            onTap: (){
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
                          child: SizedBox(
                            height: 250,
                            child:  Obx(()=>GoogleMap(
                              zoomGesturesEnabled: true, //enable Zoom in, out on map
                              onMapCreated: (GoogleMapController googleMapController){
                                controller.googleMapController=googleMapController;
                                if(controller.gController.isCompleted){}else {
                                  controller.gController
                                      .complete(googleMapController);
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
                                controller.latLng=Position(longitude: latLng.longitude, latitude: latLng.latitude, timestamp: DateTime.now(), accuracy: 1, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
                                controller.markers.add(newMarker);
                              },
                            ),
                            ),

                            /*  child: Image.asset('assets/images/map.png',height: 300,fit: BoxFit.cover,)*/)
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: primaryButton(buttonText: 'Cancel',color: AppColors.primary,textColor: AppColors.white,height: 40,fontSize: 18,onPressed: (){
                              Get.back();
                            })),
                            Expanded(child: primaryButton(buttonText: 'Done',color: AppColors.darkPink,textColor: AppColors.white,height: 40,fontSize: 18,onPressed: (){
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
           //value: controller.categoryModelDropDownInitialValue.value,
            elevation: 0,
            hint:Text(controller.categoryModelDropDownInitialValue.value.name,style:const TextStyle(color:Colors.black),),
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

  Widget addTextWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(Icons.add,color: AppColors.darkPink),
          const SizedBox(width: 10,),
          Text('Add Sub-Category',style: heading1(color: AppColors.lightPink,fontSize: 19),)
        ],
      ),
    );
  }

  Widget addLinkWidget(){
    return Obx(
          ()=> Column(
        children: [
          for(int index=0;index<controller.linkList.length;index++)
            controller.linkList[index]
        ],
      ),
    );
  }

  Widget createTextField(SocialLinkModel socialList) {
    TextEditingController linkTypeController =TextEditingController(text: socialList.url);
    controller.linkListTEController.add(linkTypeController);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: customTextField(
          controller: linkTypeController,
          hintText: 'https://abcd',
          suffixIcon:
          Padding(padding: const EdgeInsets.only(left: 10,top: 12,bottom: 12),child: Image.asset(Img.get(
              socialList.platform=="facebook"?'facebook_icon.png':
              socialList.platform=="whatsapp"?'whatsapp_icon.png' :
              socialList.platform=="instagram"?'instagram.png' :
              socialList.platform=="youtube"?'yotube_icon.png' :
              socialList.platform=="pinterest"?'pinterest.png' :
              socialList.platform=="twitter"?'twitter_icon.png' :
              socialList.platform=="reddit"?'reddit.png' :
              socialList.platform=="quora"?'quora.png':
              socialList.platform=="linkedin"?'linkedin_icon.png':"quora.png"
          )),)),
    );
  }


}