import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../utils/permission_handler.dart';
import '../utils/user_session_management.dart';
import '../web_services/general_service.dart';

class AddPromoScreenController extends GetxController{
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
  int latitude=7323232;
  int longitude=213243;

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

  RxString status="".obs;
  RxBool isStatus=false.obs;
  RxString statusErrorMessage=''.obs;
  RxBool activeSelected=false.obs,hiddenSelected=false.obs,draftSelected=false.obs;

  RxList<File> listOfImages=<File>[].obs;
  RxString additionalImagesErrMsg=''.obs;
  RxBool isAdditionalImages=false.obs;

  RxString imageErrMsg=''.obs;
  RxBool isImage=false.obs;

  PromoModel pModel=PromoModel.empty();
  RxList<Widget> linkList = <Widget>[].obs;

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

  onStatusTap(String optionStatus){
    status.value=optionStatus;
    if(optionStatus=="Active"){
      activeSelected.value=true;
      hiddenSelected.value=false;
      draftSelected.value=false;
    }else if(optionStatus=="Hidden"){
      activeSelected.value=false;
      hiddenSelected.value=true;
      draftSelected.value=false;
    }else if(optionStatus=="Draft"){
      activeSelected.value=false;
      hiddenSelected.value=false;
      draftSelected.value=true;
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

  bool statusValidation(String value) {
    if (value.trim() == "") {
      if(value.isEmpty){
        statusErrorMessage.value = "required! Please Select Status";
        isStatus.value = true;
      }
    }  else {
      isStatus.value = false;
      statusErrorMessage.value = "";
    }
    return isStatus.value;
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

  /*bool businessAddValidation(String value) {
    if (value.trim() == "") {
      if(businessNameTEController.text.isEmpty){
        businessNameErrorMsg.value = "Business Name is required!";
        businessNameErrorVisible.value = true;
      }
    }  else {
      businessNameErrorVisible.value = false;
      businessNameErrorMsg.value = "";
    }
    return businessNameErrorVisible.value;
  }*/
  Rx<CategoryModel> categoryModelDropDownInitialValue =CategoryModel.empty().obs;
  @override
  void onInit() {
   getCategory();
    super.onInit();
  }

  Future<void> getCategory() async{
    dynamic response=await GeneralService().getCategory();
    if(response is List<CategoryModel>){
      categoryModelDropDownInitialValue.value = CategoryModel(response.first.name, response.first.id);
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
    isAllDataValid = !statusValidation(status.value) && isAllDataValid;
    isAllDataValid = !additionalImagesValidation(listOfImages) && isAllDataValid;
    isAllDataValid = !imageValidation(photoImage.value) && isAllDataValid;
    if(isAllDataValid){
      businessAddressTEController.text='London';
      ProgressDialog pd = ProgressDialog();
      pModel=PromoModel(
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
        status.value,
        photoImage.value.path,
          categoryModelDropDownInitialValue.value.id,
          listOfImages,
        listOfSocialModel,
       );
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        PromoModel addPromoResponse = await PromoService().addPromo(promoModel: pModel);
        if (addPromoResponse.responseMessage=='Promo added successfully') {
          pd.dismissDialog();
          Get.offNamed(kInsideHomeRedeemScreen,arguments: addPromoResponse);
        } else {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(title: "Alert",
              description: addPromoResponse.responseMessage,
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