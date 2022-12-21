import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/model/user_detail_model.dart';
import 'package:sphere_vendor/utils/app_constants.dart';
import 'package:sphere_vendor/web_services/promo_service.dart';
import '../model/category_model.dart';
import '../model/user_login_model.dart';
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
      dynamic response=await GeneralService().getCategory();
      if(response is List<CategoryModel>){
        items.clear();
        categoryModelDropDownInitialValue.value = CategoryModel(response.first.name, response.first.id);
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
    listOfPromos.value=await PromoService().getPromo(categoryId: categoryModelDropDownInitialValue.value.id.toString(),status: 'active');
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
    Get.toNamed(kVendorDraftScreen);
  }
}