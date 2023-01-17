import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/screens/custom_widget/textStyle.dart';

import '../model/promo_model.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../screens/custom_widget/myWidgets.dart';
import '../utils/app_colors.dart';
import '../web_services/promo_service.dart';

class VendorDraftScreenController extends GetxController{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxList<PromoModel> listOfPromos=<PromoModel>[].obs;
  ProgressDialog pd = ProgressDialog();

  RxList<PromoModel> listOfSelectedPromo=<PromoModel>[].obs;
  RxString status = "".obs;
  RxInt id=0.obs;

  @override
  void onInit() {
    getPromo();
    super.onInit();
  }


  Future<void> getPromo() async{
    listOfPromos.value=await PromoService().getPromo(status: 'draft');

  }

  Future<void> onRadioButtonChange({required String statusTitle}) async{
    if(listOfSelectedPromo.isNotEmpty) {
      if(statusTitle=='Active') {
        status.value = 'active';
        id.value = 1;
      }else{
        status.value = 'hidden';
        id.value = 2;
      }
      String response = '';
      pd.showDialog(title: 'Promo Status is updating..');
      for(int i=0;i<listOfSelectedPromo.length;i++){
        response = await PromoService().updatePromoStatus(status:status.value,promoId: listOfSelectedPromo[i].id);
      }
      if (response=='status changed') {
        status.value='';
        id.value=0;
        listOfSelectedPromo.clear();
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(title: "Alert",
            description: 'Promo Status Changed Successfully',
            onOkBtnPressed: ()=>getPromo(),
            type: DialogType.ERROR);

      } else {
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(title: "Alert",
            description: response,
            type: DialogType.ERROR);
      }

    }else{
      CustomDialogs().showMessageDialog(title: "Alert",
          description: 'Please Select Promo',
          type: DialogType.ERROR);
    }
  }

  Future<void> onPopupSelect({required String statusTitle, required PromoModel promoModel}) async{
    String statusValue='';
    if(statusTitle=='Hide') {
      statusValue = 'hidden';
    }else{
      statusValue = 'active';
    }
    pd.showDialog(title: 'Promo Status is updating..');
    String response = await PromoService().updatePromoStatus(status:statusValue,promoId: promoModel.id);
    if (response=='status changed') {
      pd.dismissDialog();
      CustomDialogs().showMessageDialog(title: "Alert",
          description: 'Promo Status Changed Successfully',
          onOkBtnPressed: ()=>getPromo(),
          type: DialogType.ERROR);

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