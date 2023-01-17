import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sphere_vendor/utils/app_constants.dart';
import '../../controller/vendor_profile_screen_controller.dart';
import '../../model/category_model.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/custom_proggress_dialog.dart';
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
                        image: DecorationImage(image: controller.userLoginModelFromSession.value.userDetailModel.coverImageUrl!=''?NetworkImage(controller.userLoginModelFromSession.value.userDetailModel.coverImageUrl):controller.coverPhotoImage.value.path==""?AssetImage(Img.get('empty_record.png')):FileImage(controller.coverPhotoImage.value) as ImageProvider,fit: BoxFit.cover
                        ),
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
                            backgroundImage: controller.userLoginModelFromSession.value.userDetailModel.profileImageUrl!=''?NetworkImage(controller.userLoginModelFromSession.value.userDetailModel.profileImageUrl):controller.photoImage.value.path!=''?FileImage(controller.photoImage.value) as ImageProvider:null,
                            child:
                            controller.photoImage.value.path==''&&controller.userLoginModelFromSession.value.userDetailModel.profileImageUrl==''?
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
                    onChanged: controller.businessValidation,
                        title: 'Business Name*',hint: controller.userLoginModelFromSession.value.userDetailModel.businessName,textEditingController: controller.businessNameTEController.value),
                  ),
                  Obx(
                        ()=> Visibility(
                      visible: controller.businessNameErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.businessNameErrorMsg.value,textAlign:TextAlign.start,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                      ),
                    ),
                  ),
                  Obx(()=>formWidget(
                        onChanged: controller.fNameValidation,
                        title: 'First Name*',hint: 'Name',textEditingController: controller.fNameTEController.value),
                  ),
                  Obx(
                        ()=> Visibility(
                      visible: controller.fNameErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.fNameErrorMsg.value,textAlign:TextAlign.start,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                      ),
                    ),
                  ),
                  Obx(()=>formWidget(
                        onChanged: controller.lNameValidation,
                        title: 'Last Name*',hint: 'Last Name',textEditingController: controller.lNameTEController.value),
                  ),
                  Obx(
                        ()=> Visibility(
                      visible: controller.lNameErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.lNameErrorMsg.value,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                      ),
                    ),
                  ),
                  Obx(()=> formWidget(readOnly:true,title: 'Email*',hint: controller.userLoginModelFromSession.value.userDetailModel.uAccEmail,textEditingController: controller.emailTEController.value)),
                  Obx(()=> formWidget(
                        onChanged: controller.phoneValidation,
                        keyBoardInput: TextInputType.phone,
                        title: 'Phone Number*',hint: '+1 604 555 5555',textEditingController: controller.phNoTEController.value),
                  ),
                  Obx(
                        ()=> Visibility(
                      visible: controller.phoneErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.phoneErrorMsg.value,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                      ),
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

                      child: Obx(()=>formWidget(title: 'Business Address*',hint: 'address',textEditingController: controller.businessAddTEController.value))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: titleWidget(title: 'Select Category'),
                  ),
                      dropDown(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(
                        ()=> SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for(int i=0;i<controller.listOfSelectedIndex.length;i++)
                              selectedCategoryWidget(controller.listOfSelectedIndex[i]),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Obx(
                        ()=> Visibility(
                      visible: controller.categoryErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.categoryErrorMsg.value,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                      ),
                    ),
                  ),
                  Obx(()=> descriptionContainer(title: 'Description*',hint: 'Write about you',textEditingController: controller.descriptionTEController.value,onChanged: controller.descriptionValidation)),
                  Obx(
                        ()=> Visibility(
                      visible: controller.descriptionErrorVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(controller.descriptionErrorMsg.value,style: heading1(color: AppColors.darkPink,fontSize: 12),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60,bottom: 10),
                    child: Row(
                      children: [
                        Expanded(child: primaryButton(
                            onPressed: (){
                              Get.offNamed(kVendorHomeScreen);
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
        isDismissible: false,
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
                        Expanded(child: Text('User My Location',style:heading1(fontSize: 18))),
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
                            Expanded(child: primaryButton(buttonText: 'Cancel',color: AppColors.primary,textColor: AppColors.white,height: 40,fontSize: 18,onPressed: () async{
                             await Future.delayed(const Duration(milliseconds: 500));
                              Get.back();
                            })),
                            Expanded(child: primaryButton(buttonText: 'Done',color: AppColors.darkPink,textColor: AppColors.white,height: 40,fontSize: 18,onPressed: (){
                             Get.back();
                              controller.businessAddTEController.value.text=controller.address.value;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: Obx(
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
      ),
    );
  }

  Widget selectedCategoryWidget(CategoryModel categoryModel){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.textFieldBackground,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           Text(categoryModel.name),
            GestureDetector(
                onTap: (){
                  controller.listOfSelectedIndex.remove(categoryModel);
                 if(!controller.items.contains(categoryModel)){
                   controller.items.add(categoryModel);
                 }
                },
                child: Icon(Icons.close,color: AppColors.darkPink,size: 17,))
          ],
        ),
      ),
    );
  }

}