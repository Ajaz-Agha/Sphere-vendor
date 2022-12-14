import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sphere_vendor/model/category_model.dart';
import 'package:sphere_vendor/model/link_model.dart';
import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/utils/app_colors.dart';
import 'package:sphere_vendor/web_services/promo_service.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../screens/custom_widget/myWidgets.dart';
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../utils/permission_handler.dart';
import '../utils/user_session_management.dart';
import '../web_services/general_service.dart';

class EditPromoScreenController extends GetxController{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController productNameTEController=TextEditingController();
  TextEditingController priceTEController=TextEditingController();
  TextEditingController discountTEController=TextEditingController();
  TextEditingController discountStartTEController=TextEditingController();
  TextEditingController discountEndTEController=TextEditingController();
  TextEditingController descriptionTEController=TextEditingController();
  TextEditingController businessAddressTEController=TextEditingController();
  RxList<TextEditingController> linkListTEController=<TextEditingController>[].obs;
  TextEditingController linkTEController=TextEditingController();
  TextEditingController promoCodeTEController=TextEditingController();
  RxList<SocialLinkModel> listOfSocialModel=<SocialLinkModel>[].obs;
  RxString chosenValue=''.obs;
  RxList<CategoryModel> items=<CategoryModel>[].obs;
  double latitude=0.0;
  double longitude=0.0;

  FocusNode productNameFocusNode = FocusNode(),
      priceFocusNode = FocusNode(),discountFocusNode=FocusNode(),descFocusNode=FocusNode(),
      businessAddressFocusNode=FocusNode(),discountStartFocusNode=FocusNode(),discountEndFocusNode=FocusNode(),
      socialLinkFocusNode=FocusNode(),promoCodeFocusNode=FocusNode();
  RegExp urlPattern = RegExp(r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?");

  RxBool addLinkButtonVisible=true.obs;


  Rx<File> photoImage=File('').obs;
  UserSession userSession = UserSession();
  RxBool productNameErrorVisible = RxBool(false);
  RxString productNameErrorMsg = "".obs;
  RxBool priceErrorVisible = RxBool(false);
  RxString priceErrorMsg = "".obs;
  RxBool discountErrorVisible = RxBool(false);
  RxString discountErrorMsg = "".obs;
  RxBool discountStartErrorVisible = RxBool(false);
  RxString discountStartErrorMsg = "".obs;
  RxBool discountEndErrorVisible = RxBool(false);
  RxString discountEndErrorMsg = "".obs;
  RxBool descriptionErrorVisible = RxBool(false);
  RxString descriptionErrorMsg = "".obs;
  RxBool businessAddressErrorVisible = RxBool(false);
  RxString businessAddressErrorMsg = "".obs;
  RxList<bool> socialLinkErrorVisible = <bool>[false].obs;
  RxList<String> socialLinkErrorMsg = [""].obs;

  RxString myDate = "".obs;

  RxList<File> listOfImages=<File>[].obs;
  RxString additionalImagesErrMsg=''.obs;
  RxBool isAdditionalImages=false.obs;

  RxString imageErrMsg=''.obs;
  RxBool isImage=false.obs;

  PromoModel pModel=PromoModel.empty();
  RxList<Widget> linkList = <Widget>[].obs;

  PromoModel getPromoModel=PromoModel.empty();

  Future<bool> onBackPressed() async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      Get.back();
      return Future.value(false);
    } else {
      Get.back();
      return true;

    }

  }

  /*void addNewLink(SocialLinkModel socialLinkModel) {
    if(linkList.length<3) {
      linkList.add(socialLinkModel);
    }else{
    }
  }*/

  void removeFocus(){
    if(productNameFocusNode.hasFocus) {
      productNameFocusNode.unfocus();
    }
    if(priceFocusNode.hasFocus) {
      priceFocusNode.unfocus();
    }
    if(discountFocusNode.hasFocus) {
      discountFocusNode.unfocus();
    }if(descFocusNode.hasFocus) {
      descFocusNode.unfocus();
    }if(discountStartFocusNode.hasFocus) {
      discountStartFocusNode.unfocus();
    }if(businessAddressFocusNode.hasFocus) {
      businessAddressFocusNode.unfocus();
    }if(socialLinkFocusNode.hasFocus) {
      socialLinkFocusNode.unfocus();
    }if(promoCodeFocusNode.hasFocus) {
      promoCodeFocusNode.unfocus();
    }if(discountEndFocusNode.hasFocus) {
      discountEndFocusNode.unfocus();
    }
  }


  Future<void> onMultipleImageTap() async{
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
        CustomDialogs().uploadImageDialog(onSuccess: (source){onMultiImagePick(source);});
      }
    }catch (e){}
  }

  Future<void> onMultiImagePick(ImageSource source) async {
    ProgressDialog progressDialog = ProgressDialog();
    progressDialog.showDialog();
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        int index = pickedImage.path.lastIndexOf('/');
        if (index != -1) {
          File file = File(pickedImage.path);
          File compressedImage = await CommonCode().compressImage(file);
          listOfImages.add(compressedImage);
          if(isAdditionalImages.value){
            isAdditionalImages.value=false;
          }

        }
      }
      progressDialog.dismissDialog();
    }
    catch(exception){
      progressDialog.dismissDialog();
    }
  }

  Future<void> onImageTap() async{
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
    }catch (e){}
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
          print('---------------------------- $photoImage');
          isImage.value=false;

        }
      }
      progressDialog.dismissDialog();
    }
    catch(exception){
      progressDialog.dismissDialog();
    }
  }

  bool pNameValidation(String value) {
    if (value.trim() == "") {
      if(productNameTEController.text.isEmpty){
        productNameErrorMsg.value = "Product Name is required!";
        productNameErrorVisible.value = true;
      }
    } else if (productNameTEController.text.length<=3) {
      productNameErrorVisible.value = true;
      productNameErrorMsg.value = "Product name should be greater then 3";
    } else {
      productNameErrorVisible.value = false;
      productNameErrorMsg.value = "";
    }
    return productNameErrorVisible.value;
  }

  bool discountValidation(String value) {
    if (value.trim() == "") {
      if(discountTEController.text.isEmpty){
        discountErrorMsg.value = "Discount is required!";
        discountErrorVisible.value = true;
      }
    } else {
      discountErrorVisible.value = false;
      discountErrorMsg.value = "";
    }
    return discountErrorVisible.value;
  }

  bool discountStartDateValidation(String value) {
    if (value.trim() == "") {
      if(discountStartTEController.text.isEmpty){
        discountStartErrorMsg.value = "required!";
        discountStartErrorVisible.value = true;
      }
    } else if (discountStartTEController.text.length < 10) {
      discountStartErrorVisible.value = true;
      discountStartErrorMsg.value = "Date should be in yyyy-mm-dd format!";
    }


    else {
      discountStartErrorVisible.value = false;
      discountStartErrorMsg.value = "";
    }
    return discountStartErrorVisible.value;
  }

  bool discountEndDateValidation(String value) {
    if (value.trim() == "") {
      if(discountEndTEController.text.isEmpty){
        discountEndErrorMsg.value = "required!";
        discountEndErrorVisible.value = true;
      }
    } else if (discountEndTEController.text.length < 10) {
      discountEndErrorVisible.value = true;
      discountEndErrorMsg.value = "Date should be in yyyy-mm-dd format!";
    }

    else {
      discountEndErrorVisible.value = false;
      discountEndErrorMsg.value = "";
    }
    return discountEndErrorVisible.value;
  }

  bool priceValidation(String value) {
    if (value.trim() == "") {
      if(priceTEController.text.isEmpty){
        priceErrorMsg.value = "Price is required!";
        priceErrorVisible.value = true;
      }
    } else {
      priceErrorVisible.value = false;
      priceErrorMsg.value = "";
    }
    return priceErrorVisible.value;
  }

  /*List<bool> socialLinkValidation(String value) {
    for(int i=0;i<value.length;i++){
      if (value[i].trim() == "") {
        if(linkListTEController[i].text.isEmpty){
          socialLinkErrorMsg[i] = "Link is required!";
          socialLinkErrorVisible[i]= true;
        }
      } else {
        socialLinkErrorVisible[i]= false;
        socialLinkErrorMsg[i]= "";
      }

    }
    return socialLinkErrorVisible;



  }*/

  bool descriptionValidation(String value) {
    if (value.trim() == "") {
      if(descriptionTEController.text.isEmpty){
        descriptionErrorMsg.value = "Description is required!";
        descriptionErrorVisible.value = true;
      }
    }  else {
      descriptionErrorVisible.value = false;
      descriptionErrorMsg.value = "";
    }
    return descriptionErrorVisible.value;
  }


  bool additionalImagesValidation(List<File> value) {
    if(value.isEmpty){
      additionalImagesErrMsg.value = "Additional photos required!";
      isAdditionalImages.value = true;
    }
    else {
      isAdditionalImages.value = false;
      additionalImagesErrMsg.value = "";
    }
    return isAdditionalImages.value;
  }

  bool imageValidation(File value) {
    if(value.path.isEmpty){
      imageErrMsg.value = "Photo is required!";
      isImage.value = true;
    }
    else {
      isImage.value = false;
      imageErrMsg.value = "";
    }
    return isImage.value;
  }

  Rx<CategoryModel> categoryModelDropDownInitialValue =CategoryModel.empty().obs;

  Completer<GoogleMapController> gController = Completer<GoogleMapController>();

  Uint8List? markerImage;

  List<Marker> markers=[];
  List<Marker> listOfMarkers=[
  ];

  RxString address = ''.obs;
  Position? latLng;

  Uint8List markerIcon=Uint8List(100);



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

  Future<void> getAddressFromLatLong(Position position)async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placeMarks[0];
    address.value= '${place.locality}';

  }
  BitmapDescriptor? customIcon;
  @override

  Future<void> loadData() async{
    listOfMarkers=[
      Marker(
          icon:BitmapDescriptor.fromBytes((markerIcon)),
          markerId: const MarkerId('1'),
          position: LatLng(latLng!.latitude, latLng!.longitude),
          infoWindow: const InfoWindow(title: 'Current Location')
      )];
  }

  @override
  void onInit() {
    getPromoModel=Get.arguments;
    getCategory();
    getByteFromAsset(Img.get('location_icon.png'), 100);
    productNameTEController=TextEditingController(text: getPromoModel.productName);
    priceTEController=TextEditingController(text: getPromoModel.price);
    discountTEController=TextEditingController(text: getPromoModel.discount);
    discountStartTEController=TextEditingController(text: getPromoModel.startDate);
    discountEndTEController=TextEditingController(text: getPromoModel.endDate);
   descriptionTEController=TextEditingController(text: getPromoModel.description);
    businessAddressTEController=TextEditingController(text: getPromoModel.address);

   /*linkListTEController=<TextEditingController>[].obs;
    linkTEController=TextEditingController();*/
   // listOfSocialModel=<SocialLinkModel>[].obs;
    categoryModelDropDownInitialValue.value=CategoryModel(getPromoModel.categoryModel.name, getPromoModel.categoryModel.id);
    super.onInit();
  }

  Future<void> onLocationUpdate() async{
    businessAddressTEController.text=address.value;
    latitude=latLng!.latitude;
    longitude=latLng!.longitude;
  }

  Future<void> getCategory() async{
    dynamic response=await GeneralService().getCategory();
    if(response is List<CategoryModel>){
      //categoryModelDropDownInitialValue.value = CategoryModel(response.first.name, response.first.id);
      items.add(categoryModelDropDownInitialValue.value);
      for(CategoryModel item in response){
        items.add(CategoryModel(item.name,item.id));
      }
    }
  }

  void selectDate(teController) async {
    if (discountStartFocusNode.hasFocus) {
      discountStartFocusNode.unfocus();
    }
    try{
      DateTime now = DateTime.now();
      final date = await showDatePicker(
          context: Get.context!,
          initialDate: now,
          firstDate: now,
          lastDate: DateTime(now.year+10, now.month, now.day),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColors.primary,
                accentColor: AppColors.primary,
                colorScheme:
                ColorScheme.light(primary: AppColors.primary,),
                buttonTheme: ButtonThemeData(buttonColor: AppColors.primary,),
              ),
              child: child!,
            );
          },
          confirmText: 'SELECT'
      );
      bool isValidDate  = checkDateValidity(date);
      if(isValidDate){
        teController.text = myDate.value;

        if(teController == discountStartTEController) {
          discountStartDateValidation(discountEndTEController.text);
        } else if(teController == discountEndTEController){
          discountEndDateValidation(discountEndTEController.text);
        }

      }
    }catch(e){

    }
  }
  bool checkDateValidity(DateTime? date) {
    if (date != null && !(date.isBlank!)) {
      myDate.value = DateFormat('yyyy-MM-dd').format(date);
    } else {
    }
    return date!=null;
  }
  void onChangeDropdownForCategoryTitle(CategoryModel categoryModel) {
    categoryModelDropDownInitialValue.value = categoryModel;
  }
  Future<void> onDoneButton() async{
    List<String> platform=[];
    listOfSocialModel.clear();
    if(linkListTEController.isNotEmpty) {
      for (int i = 0; i < linkListTEController.length; i++) {
        platform.add(linkListTEController[i].text.contains('facebook')?'facebook':
        linkListTEController[i].text.contains('whatsapp')?'whatsapp':
        linkListTEController[i].text.contains('instagram')?'instagram':
        linkListTEController[i].text.contains('youtube')?'youtube':
        linkListTEController[i].text.contains('pinterest')?'pinterest':
        linkListTEController[i].text.contains('twitter')?'twitter':
        linkListTEController[i].text.contains('reddit')?'reddit':
        linkListTEController[i].text.contains('quora')?'quora':
        linkListTEController[i].text.contains('linkedin')?'linkedin':''
        );
        listOfSocialModel.add(
            SocialLinkModel(url: linkListTEController[i].text,platform: platform[i])
        );
      }
    }
    removeFocus();
    bool isAllDataValid = false;
    isAllDataValid =  !pNameValidation(productNameTEController.text);
    isAllDataValid = !priceValidation(priceTEController.text) && isAllDataValid;
    isAllDataValid = !discountValidation(discountTEController.text) && isAllDataValid;
    isAllDataValid = !discountStartDateValidation(discountStartTEController.text) && isAllDataValid;
    isAllDataValid = !discountEndDateValidation(discountEndTEController.text) && isAllDataValid;
    isAllDataValid = !descriptionValidation(descriptionTEController.text) && isAllDataValid;
    if(isAllDataValid){
      businessAddressTEController.text='London';
      ProgressDialog pd = ProgressDialog();
      pModel=PromoModel.forEdit(
        getPromoModel.id,
        productNameTEController.text,
        priceTEController.text,
        discountTEController.text,
        discountStartTEController.text,
        discountEndTEController.text,
        descriptionTEController.text,
        businessAddressTEController.text,
        latitude.toString(),
        longitude.toString(),
        promoCodeTEController.text,
        photoImage.value.path,
        categoryModelDropDownInitialValue.value.id,
        listOfImages,
        listOfSocialModel,
      );
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        PromoModel editPromoResponse = await PromoService().editPromo(promoModel: pModel);
        if (editPromoResponse.responseMessage=='Promo updated') {
          pd.dismissDialog();
          Get.offNamed(kInsideHomeRedeemScreen,arguments: editPromoResponse);
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(title: "Alert",
              description: editPromoResponse.responseMessage,
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
}