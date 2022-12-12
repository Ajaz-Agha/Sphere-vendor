import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/controller/vendor_draft_screen_controller.dart';
import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class VendorDraftScreen extends GetView<VendorDraftScreenController>{
  const VendorDraftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        key: controller.scaffoldKey,
        body: _getBody(context)
    );
  }

  Widget _getBody(BuildContext  context){
    return SafeArea(
        child:Stack(
            children: [
              imageIcon(img: 'splash_screen_bg2.png',size: 150),
              Align(
                alignment: Alignment.bottomRight,
                child: imageIcon(img: 'splash_screen_bg3.png',size: 100),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  Get.back();
                                },
                                child: Icon(Icons.arrow_back,color: AppColors.primary,)),
                            Text('Draft',style: heading1SemiBold(color: AppColors.primary,fontSize: 20),),
                            const SizedBox()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text('Please select for Active/Hide',style: heading1(color: AppColors.primary,fontSize: 17),),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Obx(
                                        ()=> Radio(
                                        activeColor: AppColors.darkPink,
                                        value: 1, groupValue: controller.id.value, onChanged: (index){
                                      controller.onRadioButtonChange(statusTitle: 'Active');
                                    }),
                                  ),
                                  Expanded(
                                    child: Text('Active',style: heading1(color: AppColors.primary,fontSize: 17),),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Obx(
                                        ()=> Radio(
                                        activeColor: AppColors.darkPink,
                                        value: 2, groupValue: controller.id.value, onChanged: (index) {
                                      controller.onRadioButtonChange(statusTitle: 'Hide');

                                    }),
                                  ),
                                  Expanded(child: Text('Hide',style: heading1(color: AppColors.primary,fontSize: 17),))
                                ],
                              ),
                            ),
                            Obx(()=>Text('Select ${controller.listOfSelectedPromo.length}',style: heading1(color: AppColors.lightPink,fontSize: 17),))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child:  Obx(()=> controller.listOfPromos.isEmpty? showEmptyListMessage(message: 'No Record Found'):
                      ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: controller.listOfPromos.length,
                          itemBuilder: (BuildContext context,int index){
                            return fullCard(promoModel: controller.listOfPromos[index]);
                          }
                      ),
                      )
                  )
                ],
              ),
            ]
        )
    );
  }


  Widget fullCard({required PromoModel promoModel}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        children: [
          Container(
            height: 128,
            width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: NetworkImage(promoModel.promoImageUrl),fit: BoxFit.cover)
            ),
            padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _checkBox(false.obs,promoModel),
                popUpMenu(promoModel)
              ],
            ),
          ),
          const SizedBox(height: 3,),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(promoModel.productName,style: bodyMediumMedium(color: AppColors.primary,fontSize: 18,fontWeight: FontWeight.w800))),
                  const Icon(Icons.remove_red_eye_outlined,size: 16),
                  Text(' 10',style: heading1SemiBold(color: AppColors.darkPink,fontSize: 10),),
                ],),
              Row(
                children: [
                  const Expanded(child: Text('Sofa, Bed, Chair, Office Furniture')),
                  const SizedBox(width: 12),
                  Icon(Icons.star,color: AppColors.iconColor,size: 13,),
                  const SizedBox(width: 4,),
                  Text('4.5',style: bodyMediumMedium(color: AppColors.primary,fontSize: 13),),
                  Text('(5)',style: heading1(color: AppColors.a4Color,fontSize: 10),)

                ],),
            ],
          )
        ],
      ),
    );
  }

  Widget radioButtonWidget({required String title, required bool isEnable}){
    return Row(
      children: [
        Text(title,style: heading1(color: AppColors.primary,fontSize: 17),),
        const SizedBox(width: 6),
        CircleAvatar(
          backgroundColor: AppColors.darkPink,
          maxRadius: 7,
          child: CircleAvatar(
            backgroundColor: AppColors.white,
            maxRadius: !isEnable?6:4,
          ),
        )
      ],
    );
  }

  Widget _checkBox(RxBool val,PromoModel promoModel) {
    return Obx(() {
      return Checkbox(
          checkColor: Colors.white,
          activeColor: AppColors.darkPink,
          value: val.value,
          side: BorderSide(
              color: AppColors.darkPink.withAlpha(0999), width: 1),
          onChanged: (value) async{
            val.value = !val.value;
            if(val.value) {
              controller.listOfSelectedPromo.add(promoModel);
            }else{
              controller.listOfSelectedPromo.remove(promoModel);
            }
          });
    });
  }

  Widget popUpMenu(PromoModel promoModel){
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("Edit",textAlign: TextAlign.center,),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("Activate",textAlign: TextAlign.center,),
        ),
        const PopupMenuItem(
          value: 3,
          child: Text("Hide",textAlign: TextAlign.center,),
        ),

      ],
      color: Colors.white,
      onSelected: (value) {
        if (value == 1) {
          customDialog(promoModel);
        } else if (value == 2) {
          controller.onPopupSelect(statusTitle: 'Active',promoModel: promoModel);
        }else if (value==3){
          controller.onPopupSelect(statusTitle: 'Hide',promoModel: promoModel);
        }
      },
    );
  }

}