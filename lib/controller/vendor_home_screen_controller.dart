import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/model/user_detail_model.dart';
import 'package:sphere_vendor/utils/app_colors.dart';
import 'package:sphere_vendor/utils/app_constants.dart';
import 'package:sphere_vendor/web_services/promo_service.dart';
import '../model/category_model.dart';
import '../model/user_login_model.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../screens/custom_widget/myWidgets.dart';
import '../screens/custom_widget/textStyle.dart';
import '../utils/common_code.dart';
import '../utils/user_session_management.dart';
import '../web_services/general_service.dart';

class VendorHomeScreenController extends GetxController{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxString chosenValue=''.obs;
  RxList<CategoryModel> items=<CategoryModel>[].obs;
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  RxList<PromoModel> listOfPromos=<PromoModel>[].obs;
  Rx<CategoryModel> categoryModelDropDownInitialValue =CategoryModel.empty().obs;
  Rx<UserDetailModel> userFromService=UserDetailModel.empty().obs;
  UserSession userSession=UserSession();
  Rx<UserLoginModel> userLoginModel=UserLoginModel.empty().obs;
  Future<void> getUserFromSession() async{
    userLoginModel.value=await userSession.getUserLoginModel();
  }
  ProgressDialog pd = ProgressDialog();


  @override
  void onInit() {
    getCategory();
    super.onInit();
  }

  @override
  void onReady() {
    refreshIndicatorKey.currentState!.show();
    super.onReady();
  }

  Future<void> getCategory() async{
    if(await CommonCode().checkInternetAccess()) {
      dynamic response=await GeneralService().getVendorsCategory();
      if(response is List<CategoryModel>){
        items.clear();
        categoryModelDropDownInitialValue.value = CategoryModel('Please Select Category', -1);
        items.add(categoryModelDropDownInitialValue.value);
        for(CategoryModel item in response){
          items.add(CategoryModel(item.name,item.id));
        }
        getPromo();
      }
    }else{
      getUserFromSession();
    }

  }

  Future<void> getPromo() async{
    if(categoryModelDropDownInitialValue.value.id==-1){
      listOfPromos.value=await PromoService().getPromo(status: 'active');
    }else{
      listOfPromos.value=await PromoService().getPromo(categoryId: categoryModelDropDownInitialValue.value.id.toString(),status: 'active');
    }

    if(listOfPromos.isNotEmpty) {
      for (int i = 0; i < listOfPromos.length; i++) {
        userFromService.value = listOfPromos[i].userDetailModel;
      }
    }else{
      getUserFromSession();
    }
  }

  void onChangeDropdownForCategoryTitle(CategoryModel categoryModel) {
    categoryModelDropDownInitialValue.value = categoryModel;
    getPromo();
  }

  void onDraftTap(){
    Get.offNamed(kVendorDraftScreen);
  }

  Future<void> onPopupSelect({required String statusTitle, required PromoModel promoModel}) async{
    String statusValue='';
    if(statusTitle=='Hide') {
      statusValue = 'hidden';
    }else{
      statusValue = 'draft';
    }
    pd.showDialog(title: 'Promo Status is updating..');
    String response = await PromoService().updatePromoStatus(status:statusValue,promoId: promoModel.id);
    if (response=='status changed') {
      await getPromo();
      pd.dismissDialog();
    /*  CustomDialogs().showMessageDialog(title: "Alert",
          description: 'Promo Status Changed Successfully',
          onOkBtnPressed: ()=>getPromo(),
          type: DialogType.ERROR);*/

    } else {
      pd.dismissDialog();
      CustomDialogs().showMessageDialog(title: "Alert",
          description: response,
          type: DialogType.ERROR);
    }

  }

  Future<void> deletePromo(PromoModel promoModel) async{
   customDialog(promoModel);
  }


  Future customDialog(PromoModel promoModel){
    return Get.dialog(
        Dialog(
          shape: const RoundedRectangleBorder(borderRadius:
          BorderRadius.all(Radius.circular(30))),
          child: Container(
            width: Get.width,
            height: 180,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.close,size: 20,color: AppColors.darkPink,)),
                ),
                Text('Are You Sure?',style: heading1SemiBold(color: AppColors.primary,fontSize: 20),),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: primaryButton(height: 40,radius: 9,buttonText: 'No',textColor: AppColors.white,fontSize: 18,onPressed: (){
                      Get.back();
                    })),
                    Expanded(child: primaryButton(height: 40,color: AppColors.darkPink,radius: 9,buttonText: 'Yes',textColor: AppColors.white,fontSize: 18,
                        onPressed: () async{
                      Get.back();
                      pd.showDialog(title: 'Promo is Deleting..');
                      String response = await PromoService().deletePromo(promoId: promoModel.id);
                      if (response=='Promo successfully deleted.') {
                        await getPromo();
                        pd.dismissDialog();
                        /*  CustomDialogs().showMessageDialog(title: "Alert",
          description: 'Promo Status Changed Successfully',
          onOkBtnPressed: ()=>getPromo(),
          type: DialogType.ERROR);*/

                      } else {
                        pd.dismissDialog();
                        CustomDialogs().showMessageDialog(title: "Alert",
                            description: response,
                            type: DialogType.ERROR);
                      }
                    })),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}