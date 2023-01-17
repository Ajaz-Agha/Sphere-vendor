import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sphere_vendor/model/location_model.dart';
import 'package:sphere_vendor/screens/custom_widget/myWidgets.dart';
import '../model/category_model.dart';
import '../model/user_login_model.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../utils/permission_handler.dart';
import '../utils/user_session_management.dart';
import '../web_services/general_service.dart';
import '../web_services/user_service.dart';

class VendorProfileScreenController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Rx<TextEditingController> fNameTEController=TextEditingController().obs;
  Rx<TextEditingController> lNameTEController=TextEditingController().obs;
  Rx<TextEditingController> emailTEController=TextEditingController().obs;
  Rx<TextEditingController> phNoTEController=TextEditingController().obs;
  Rx<TextEditingController> businessNameTEController=TextEditingController().obs;
  Rx<TextEditingController> descriptionTEController=TextEditingController().obs;
  Rx<TextEditingController> businessAddTEController=TextEditingController().obs;

  Position? latLng;
  double longitude=0.0;
  double latitude=0.0;

  RxList<String> linkList = <String>[].obs;

  FocusNode fNameFocusNode = FocusNode(),
      lNameFocusNode = FocusNode(),phoneFocusNode=FocusNode(),descFocusNode=FocusNode(),businessNameFocusNode=FocusNode();
   Uint8List markerIcon=Uint8List(100);
  UserLoginModel userLoginModel=UserLoginModel.empty();
  Rx<File> photoImage=File('').obs;
  Rx<File> coverPhotoImage=File('').obs;

  RxBool fNameErrorVisible = RxBool(false);
  RxString fNameErrorMsg = "".obs;
  RxBool lNameErrorVisible = RxBool(false);
  RxString lNameErrorMsg = "".obs;
  RxBool categoryErrorVisible = RxBool(false);
  RxString categoryErrorMsg = "".obs;
  RxBool phoneErrorVisible = RxBool(false);
  RxString phoneErrorMsg = "".obs;
  RxBool descriptionErrorVisible = RxBool(false);
  RxString descriptionErrorMsg = "".obs;
  RxBool businessNameErrorVisible = RxBool(false);
  RxString businessNameErrorMsg = "".obs;
  RxList<CategoryModel> items=<CategoryModel>[].obs;

  UserSession userSession = UserSession();
  GoogleMapController? googleMapController;
  final Mode mode = Mode.overlay;
  String kGoogleApiKey='AIzaSyDa7rKiTOjGg8pyZddXF_CEjZ7mL63RKTA';

 CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

 Completer<GoogleMapController> gController = Completer<GoogleMapController>();

 Uint8List? markerImage;

  RxList<Marker> markers=<Marker>[].obs;
 List<Marker> listOfMarkers=[
 ];

  RxString address = ''.obs;
  RxString selection=''.obs;
  RxList<CategoryModel> listOfSelectedIndex=<CategoryModel>[].obs;
  Rx<CategoryModel> categoryModelDropDownInitialValue =CategoryModel('Please Select Category', -1).obs;

 

 Future<void> getByteFromAsset(String path, int width) async{
   ByteData byteData=await rootBundle.load(path);
   ui.Codec codec=await ui.instantiateImageCodec(byteData.buffer.asUint8List(),targetHeight: width);
   ui.FrameInfo fi=await codec.getNextFrame();
   markerIcon= (await fi.image.toByteData(format:ui.ImageByteFormat.png))!.buffer.asUint8List();
 }

 Future<void> getCurrentPosition() async{
   bool serviceEnabled;
   LocationPermission permission;
   serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       CustomDialogs().showMessageDialog(title: 'Alert',
           description:'Location services are disabled, Please Turn on Location',
           type: DialogType.ERROR);
     }


   permission = await Geolocator.checkPermission();
   if (permission == LocationPermission.denied) {
     permission = await Geolocator.requestPermission();
     if (permission == LocationPermission.denied) {
       CustomDialogs().showMessageDialog(title: 'Alert',
           description:'Location permissions are denied',
           type: DialogType.ERROR);
     }
   }
   if (permission == LocationPermission.deniedForever) {
     CustomDialogs().showMessageDialog(title: 'Alert',
         description:'Location permissions are permanently denied, we cannot request permissions.',
         type: DialogType.ERROR);
   }
   latLng=await Geolocator.getCurrentPosition();
   getAddressFromLatLong(latLng!);
 }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    markers.clear();
    markers.add(Marker(markerId: const MarkerId("1"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result.name),icon:BitmapDescriptor.fromBytes((markerIcon)),));
    if(detail.result.formattedAddress!='') {
      address.value = detail.result.formattedAddress!;
    }
    latLng!.latitude!=detail.result.geometry!.location.lat;
    latLng!.longitude!=detail.result.geometry!.location.lng;
    latitude=detail.result.geometry!.location.lat;
    longitude=detail.result.geometry!.location.lng;
    latLng=Position(longitude: longitude, latitude: latitude, timestamp: DateTime.now(), accuracy: 1, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));

  }

  Future<void> getAddressFromLatLong(Position position)async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placeMarks[0];
    address.value= '${place.name} ${place.subLocality} ${place.locality}';

  }
  Future<void> getCategory() async{
    dynamic response=await GeneralService().getCategory();
    if(response is List<CategoryModel>){
      for(int i=0;i<listOfSelectedIndex.length;i++){
        for(int j=0;j<response.length;j++){
          if(listOfSelectedIndex[i].id==response[j].id){
            response.removeAt(j);
          }
        }

      }
      //categoryModelDropDownInitialValue.value = CategoryModel(response.first.name, response.first.id);
      items.add(categoryModelDropDownInitialValue.value);
      for(CategoryModel item in response){
        items.add(CategoryModel(item.name,item.id));
      }
    }
  }
  void onChangeDropdownForCategoryTitle(CategoryModel categoryModel) {
    categoryModelDropDownInitialValue.value = categoryModel;
    //items.remove(categoryModelDropDownInitialValue.value);
    if(!listOfSelectedIndex.contains(categoryModel) && categoryModelDropDownInitialValue.value.id!=-1) {
      listOfSelectedIndex.add(categoryModel);
    }
  }


  Future<bool> onBackPressed() async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      Get.offNamed(kVendorHomeScreen);
      return Future.value(false);
    } else {
      Get.offNamed(kVendorHomeScreen);
      return true;

    }

  }

  Rx<UserLoginModel> userLoginModelFromSession=UserLoginModel.empty().obs;

  BitmapDescriptor? customIcon;

// make sure to initialize before map loading

  @override
  void onInit() {
    getUserFromSession();
    getCategory();
    getByteFromAsset(Img.get('location_icon.png'), 100);
    super.onInit();
  }

  customMarker(){
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(12, 12)),
        Img.get('location_png.icon'))
        .then((d) {
      customIcon = d;
    });
  }



  Future<void> loadData() async{
    listOfMarkers=[
      Marker(
      icon:BitmapDescriptor.fromBytes((markerIcon)),
        markerId: const MarkerId('1'),
        position: LatLng(latLng!.latitude, latLng!.longitude),
        infoWindow: const InfoWindow(title: 'Current Location')
    )];
  }

  Future<void> getUserFromSession() async{
    userLoginModelFromSession.value=await userSession.getUserLoginModel();
    emailTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.uAccEmail);
    businessNameTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.businessName);
    if(userLoginModelFromSession.value.userDetailModel.firstName!=''){
      fNameTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.firstName);
    }  if(userLoginModelFromSession.value.userDetailModel.lastName!=''){
      lNameTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.lastName);
    }  if(userLoginModelFromSession.value.userDetailModel.phone!=''){
      phNoTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.phone);
    }if(userLoginModelFromSession.value.userDetailModel.description!=''){
      descriptionTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.description);
    }
    for(int i=0;i<userLoginModelFromSession.value.userDetailModel.listOfCategories.length;i++){
      listOfSelectedIndex.add(userLoginModelFromSession.value.userDetailModel.listOfCategories[i]);
    }
    for(int i=0;i<userLoginModelFromSession.value.userDetailModel.locationModelList.length;i++){
      if(userLoginModelFromSession.value.userDetailModel.locationModelList[i].address!=''
      && userLoginModelFromSession.value.userDetailModel.locationModelList[i].isDefault==1
      ){
        businessAddTEController.value=TextEditingController(text: userLoginModelFromSession.value.userDetailModel.locationModelList[i].address);
      }
    }
  }

  void removeFocus(){
    if(fNameFocusNode.hasFocus) {
      fNameFocusNode.unfocus();
    }
    if(lNameFocusNode.hasFocus) {
      lNameFocusNode.unfocus();
    }
    if(phoneFocusNode.hasFocus) {
      phoneFocusNode.unfocus();
    }if(descFocusNode.hasFocus) {
      descFocusNode.unfocus();
    }if(businessNameFocusNode.hasFocus) {
      businessNameFocusNode.unfocus();
    }
  }

Future<void> onUploadImage() async{
  try{
    bool hasCameraPermission=await PermissionsHandler().requestPermission(permission: Permission.camera,
      onPermissionDenied:(){
        CustomDialogs().showErrorDialog(
          kPermissionDenied,
          kCameraPermissionDenied,
          DialogType.ERROR,
          Colors.red,
        );
      },
      onPermissionPermanentlyDenied: (){

        CustomDialogs().showErrorDialog(
          kPermissionDenied,
          "Camera $kPermissionPermanentlyDenied",
          DialogType.ERROR,
          Colors.red,
        );
      },
    );
    if(hasCameraPermission) {
      CustomDialogs().uploadImageDialog(onSuccess: (source){onImagePick(source);});
    }
  }catch (e){
  }
}

  Future<void> onImagePick(ImageSource source) async {
    ProgressDialog progressDialog = ProgressDialog();
    progressDialog.showDialog();
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        int index = pickedImage.path.lastIndexOf('/');
        if (index != -1) {
          File file = File(pickedImage.path);
          File compressedImage = await CommonCode().compressImage(file);
          photoImage.value=compressedImage;
          userLoginModelFromSession.value.userDetailModel.profileImageUrl='';
          if (await CommonCode().checkInternetConnection()) {
            /* var result = await UserService().updateProfilePhoto(userAccountId: AppSettings.userLoginModel.value.uAccId, imgPath: compressedImage.path);
            if(result is ResponseModel){
              String imageName = result.data.toString().split("/").last;
              AppSettings.userLoginModel.value.profilePicPath = "uploads/${AppSettings.userLoginModel.value.uAccId}/$imageName";
              await UserSession().updateSessionData(AppSettings.userLoginModel.value);
              AppSettings.userLoginModel.refresh();
              progressDialog.dismissDialog();
            }
            else{
              progressDialog.dismissDialog();
              CustomDialogs().showDialog("Alert", result, DialogType.ERROR, Colors.red);
            }*/
            progressDialog.dismissDialog();
          } else {
            progressDialog.dismissDialog();
            CustomDialogs().showMessageDialog(
                title: 'Alert', description: kInternetMsg, type: DialogType.ERROR);
          }

        }
      }
      progressDialog.dismissDialog();
    }
    catch(exception){
      progressDialog.dismissDialog();
    }
  }

  Future<void> onUploadCoverImage() async{
    try{
      bool hasCameraPermission=await PermissionsHandler().requestPermission(permission: Permission.camera,
        onPermissionDenied:(){
          CustomDialogs().showErrorDialog(
            kPermissionDenied,
            kCameraPermissionDenied,
            DialogType.ERROR,
            Colors.red,
          );
        },
        onPermissionPermanentlyDenied: (){

          CustomDialogs().showErrorDialog(
            kPermissionDenied,
            "Camera $kPermissionPermanentlyDenied",
            DialogType.ERROR,
            Colors.red,
          );
        },
      );
      if(hasCameraPermission) {
        CustomDialogs().uploadImageDialog(onSuccess: (source){onCoverImagePick(source);});
      }
    }catch (e){
    }
  }
  Future<void> onCoverImagePick(ImageSource source) async {
    ProgressDialog progressDialog = ProgressDialog();
    progressDialog.showDialog();
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        int index = pickedImage.path.lastIndexOf('/');
        if (index != -1) {
          File file = File(pickedImage.path);
          File compressedImage = await CommonCode().compressImage(file);
          coverPhotoImage.value=compressedImage;
          userLoginModelFromSession.value.userDetailModel.coverImageUrl='';
          if (await CommonCode().checkInternetConnection()) {
            /* var result = await UserService().updateProfilePhoto(userAccountId: AppSettings.userLoginModel.value.uAccId, imgPath: compressedImage.path);
            if(result is ResponseModel){
              String imageName = result.data.toString().split("/").last;
              AppSettings.userLoginModel.value.profilePicPath = "uploads/${AppSettings.userLoginModel.value.uAccId}/$imageName";
              await UserSession().updateSessionData(AppSettings.userLoginModel.value);
              AppSettings.userLoginModel.refresh();
              progressDialog.dismissDialog();
            }
            else{
              progressDialog.dismissDialog();
              CustomDialogs().showDialog("Alert", result, DialogType.ERROR, Colors.red);
            }*/
            progressDialog.dismissDialog();
          } else {
            progressDialog.dismissDialog();
            CustomDialogs().showMessageDialog(
                title: 'Alert', description: kInternetMsg, type: DialogType.ERROR);
          }

        }
      }
      progressDialog.dismissDialog();
    }
    catch(exception){
      progressDialog.dismissDialog();
    }
  }

  bool fNameValidation(String value) {
    if (value.trim() == "") {
      if(fNameTEController.value.text.isEmpty){
        fNameErrorMsg.value = "First Name is required!";
        fNameErrorVisible.value = true;
      }
    } else if (fNameTEController.value.text.length<=3) {
      fNameErrorVisible.value = true;
      fNameErrorMsg.value = "First name should be greater then 3";
    } else {
      fNameErrorVisible.value = false;
      fNameErrorMsg.value = "";
    }
    return fNameErrorVisible.value;
  }

  bool lNameValidation(String value) {
    if (value.trim() == "") {
      if(lNameTEController.value.text.isEmpty){
        lNameErrorMsg.value = "Last Name is required!";
        lNameErrorVisible.value = true;
      }
    } else if (lNameTEController.value.text.length<=3) {
      lNameErrorVisible.value = true;
      lNameErrorMsg.value = "Last name should be greater then 3";
    } else {
      lNameErrorVisible.value = false;
      lNameErrorMsg.value = "";
    }
    return lNameErrorVisible.value;
  }

  bool categoryValidation(List<CategoryModel> value) {
    if (value.isEmpty) {
        categoryErrorMsg.value = "Category is Required!";
        categoryErrorVisible.value = true;
    } else {
      categoryErrorVisible.value = false;
      categoryErrorMsg.value = "";
    }
    return categoryErrorVisible.value;
  }

  bool phoneValidation(String value) {
    if (value.trim() == "") {
      if(phNoTEController.value.text.isEmpty){
        phoneErrorMsg.value = "Phone number is required!";
        phoneErrorVisible.value = true;
      }
    } else if (!RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$').hasMatch(value)) {
      phoneErrorVisible.value = true;
      phoneErrorMsg.value = "Invalid Phone Number";
    } else {
      phoneErrorVisible.value = false;
      phoneErrorMsg.value = "";
    }
    return phoneErrorVisible.value;
  }

  bool descriptionValidation(String value) {
    if (value.trim() == "") {
      if(descriptionTEController.value.text.isEmpty){
        descriptionErrorMsg.value = "Description is required!";
        descriptionErrorVisible.value = true;
      }
    }  else {
      descriptionErrorVisible.value = false;
      descriptionErrorMsg.value = "";
    }
    return descriptionErrorVisible.value;
  }

  bool businessValidation(String value) {
    if (value.trim() == "") {
      businessNameErrorVisible.value = true;
      businessNameErrorMsg.value = "Business name is required!";
    } else if (value.trim().length < 5 ||
        value.isEmpty) {
      businessNameErrorVisible.value = true;
      businessNameErrorMsg.value = "Invalid";
    }
    else {
      businessNameErrorVisible.value = false;
      businessNameErrorMsg.value = "";
    }
    return businessNameErrorVisible.value;
  }


  Future<void> onUpdateButton() async{
    removeFocus();
    bool isAllDataValid = false;
    isAllDataValid =  !businessValidation(businessNameTEController.value.text);
    isAllDataValid = !fNameValidation(fNameTEController.value.text)  && isAllDataValid;
    isAllDataValid = !lNameValidation(lNameTEController.value.text) && isAllDataValid;
    isAllDataValid = !phoneValidation(phNoTEController.value.text) && isAllDataValid;
    isAllDataValid = !categoryValidation(listOfSelectedIndex) && isAllDataValid;
    isAllDataValid = !descriptionValidation(descriptionTEController.value.text) && isAllDataValid;
    if(isAllDataValid){
      userLoginModel.userDetailModel.profileImage=photoImage.value.path.split('/').reversed.first;
      userLoginModel.userDetailModel.coverImage=coverPhotoImage.value.path.split('/').reversed.first;
      userLoginModel.userDetailModel.firstName=fNameTEController.value.text;
      userLoginModel.userDetailModel.lastName=lNameTEController.value.text;
      userLoginModel.userDetailModel.phone=phNoTEController.value.text;
      userLoginModel.userDetailModel.description=descriptionTEController.value.text;
      userLoginModel.userDetailModel.listOfCategories=listOfSelectedIndex;
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        UserLoginModel userLoginModelResp = await UserService().updateProfile(userLoginModelForUpdate: userLoginModel,imgPath: photoImage.value.path,coverImagePath: coverPhotoImage.value.path);
        UserLoginModel userLoginFromSession=await userSession.getUserLoginModel();
        userLoginModelResp.token=userLoginFromSession.token;
        if (userLoginModelResp.requestErrorMessage=='Profile Updated successfully') {
          userSession.updateSessionData(userLoginModelResp);
          pd.dismissDialog();
          Get.offNamed(kVendorHomeScreen);
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(title: "Alert",
              description: userLoginModelResp.requestErrorMessage,
              type: DialogType.ERROR);
        }
      } else{
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(title: 'Alert',
            description: kInternetMsg,
            type: DialogType.ERROR);
      }


    }
  }

  Future<void> onLocationUpdate() async{
    if(businessAddTEController.value.text!=''){
      LocationModel locationModel=LocationModel(address: businessAddTEController.value.text, latitude: latLng!.latitude.toString(), longitude: latLng!.longitude.toString());
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        String response=await UserService().updateLocation(locationModel: locationModel);
        if (response=='Location Updated successfully') {
          userLoginModelFromSession.value.userDetailModel.locationModelList.add(locationModel);
          locationModel.isDefault=1;
          userSession.updateSessionData(userLoginModelFromSession.value);
          pd.dismissDialog();
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(title: "Alert",
              description: response,
              type: DialogType.ERROR);
        }
      } else{
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(title: 'Alert',
            description: kInternetMsg,
            type: DialogType.ERROR);
      }

    }

    }


  @override
  void dispose() {
    fNameTEController.value.dispose();
    lNameTEController.value.dispose();
    phNoTEController.value.dispose();
    descriptionTEController.value.dispose();
    emailTEController.value.dispose();

    super.dispose();
  }
}