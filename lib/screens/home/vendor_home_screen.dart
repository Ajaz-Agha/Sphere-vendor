import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/controller/vendor_home_screen_controller.dart';
import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/screens/custom_widget/custom_navigation_drawer.dart';
import 'package:sphere_vendor/utils/app_constants.dart';
import '../../model/category_model.dart';
import '../../utils/app_colors.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class VendorHomeScreen extends GetView<VendorHomeScreenController>{
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        key: controller.scaffoldKey,
        body: _getBody(context),
        drawer: const CustomNavigationDrawer(),
      ),
    );
  }
  Widget _getBody(BuildContext context){
    return RefreshIndicator(
      key: controller.refreshIndicatorKey,
      onRefresh: controller.getPromo,
      child: Container(
        color: AppColors.white,
        height: Get.height,
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            SafeArea(
              child: Stack(
                  children: [
                    Obx(
                          ()=> Container(
                        height: 180,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: controller.userFromService.value.coverImageUrl!=''?NetworkImage(controller.userFromService.value.coverImageUrl):controller.userLoginModel.value.userDetailModel.coverImageUrl!=''?NetworkImage(controller.userLoginModel.value.userDetailModel.coverImageUrl):AssetImage(Img.get('sphere_logo.png')) as ImageProvider,fit:
                            controller.userFromService.value.coverImageUrl==''&&controller.userLoginModel.value.userDetailModel.coverImageUrl==''
                            ?BoxFit.contain:BoxFit.cover,
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
                                controller.scaffoldKey.currentState!.openDrawer();
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              child: Image.asset("assets/images/menu_icon.png",width: 20,height: 20,),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.textFieldBackground,
                                  borderRadius: BorderRadius.circular(7)
                                ),
                                child: Text('My Business Profile',style: heading1SemiBold(fontSize: 20,color: AppColors.primary),)),
                            const SizedBox()
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
                          child: Obx(
                                ()=> CircleAvatar(
                             maxRadius: 100,
                              backgroundColor: AppColors.white,
                              backgroundImage: controller.userFromService.value.profileImageUrl!=''?NetworkImage(controller.userFromService.value.profileImageUrl):controller.userLoginModel.value.userDetailModel.profileImageUrl!=''?NetworkImage(controller.userLoginModel.value.userDetailModel.profileImageUrl):AssetImage(Img.get('user.png')) as ImageProvider,
                            ),
                          ),
                        ),
                      ],),
                  ]
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description',style: heading1SemiBold(color: AppColors.primary,fontSize: 17),),
                                const SizedBox(height: 13,),
                                Obx(()=> Text(controller.userLoginModel.value.userDetailModel.description!=''?controller.userLoginModel.value.userDetailModel.description:controller.userFromService.value.description,style:heading1(color: AppColors.primary,fontSize: 15),)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                            //  crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                 // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  width: 100,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: AppColors.darkPink,width: 1)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.favorite,color: AppColors.darkPink,size: 15,),
                                      const SizedBox(width: 6,),
                                      Obx(() => Text(controller.userFromService.value.totalFav.value.toString()))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                primaryButton(color: AppColors.darkPink,height: 25,radius: 5,buttonText: '+ Add Promo',textColor: AppColors.white,
                                onPressed: (){
                                  Get.toNamed(kAddPromoScreen);
                                }),
                                ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                      child:Row(
                        children: [
                          Text('Select Category',style: heading1SemiBold(color: AppColors.primary,fontSize: 15)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: shapeIconContainer('shapes_icon.png'),

                          ),
                          dropDown()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                      child:Row(
                        children: [
                          Expanded(child: Text('My Promos',style: headingBold(color: AppColors.primary,fontSize: 18,fontWeight: FontWeight.w700))),
                          GestureDetector(
                              onTap: (){
                                controller.onDraftTap();
                              },
                              child: optionContainer('Draft')),

                        ],
                      ),

                    ),
                    Obx(()=> controller.listOfPromos.isEmpty? showEmptyListMessage(message: 'No Record Found'):
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.listOfPromos.length,
                        itemBuilder: (BuildContext context,int index){
                          return fullCard(promoModel: controller.listOfPromos[index]);
                        }
                    ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fullCard({required PromoModel promoModel}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              Get.toNamed(kInsideHomeRedeemScreen,arguments: promoModel);
            },
            child: Container(
              height: 128,
              width: Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: NetworkImage(promoModel.promoImageUrl),fit: BoxFit.cover)
              ),
              padding: const EdgeInsets.only(top: 10,right: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      Icon(Icons.favorite,color: AppColors.white),
                      Text('0',style: heading1(color: AppColors.a4Color,fontSize: 10),)
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 3,),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(promoModel.productName,style: heading1SemiBold(color: AppColors.primary,fontSize: 15))),
                  const Icon(Icons.remove_red_eye_outlined,size: 16),
                  Text(' 100',style: heading1SemiBold(color: AppColors.darkPink,fontSize: 10),),
                ],),
              Row(
                children: [
                  Expanded(child: Text(promoModel.userDetailModel.businessName)),
                  const SizedBox(width: 12),
                  Icon(Icons.star,color: AppColors.iconColor,size: 13,),
                  const SizedBox(width: 4,),
                  Text('4.5',style: bodyMediumMedium(color: AppColors.primary,fontSize: 13),),
                  Text('(10)',style: heading1(color: AppColors.a4Color,fontSize: 10),)

                ],),
            ],
          )
        ],
      ),
    );
  }
  
  Widget optionContainer(String title){
    return  Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 20),
          decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Text(title,style: bodyMediumMedium(fontSize: 14,color: const Color(0xFF505050)),)
      ),
    );
  }

  Widget shapeIconContainer(String image){
    return  Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(5)
          ),
          child: imageIcon(img: image)
      ),
    );
  }

  Widget dropDown(){
    return Obx(
      ()=> Container(
        width: 120,
        height: 34,
        decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
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
            items: controller.items.map<DropdownMenuItem<CategoryModel>>((value)  {
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



}