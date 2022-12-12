import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/utils/app_colors.dart';
import '../../controller/home_redeem_inside_screen_controller.dart';
import '../custom_widget/myWidgets.dart';
import '../custom_widget/textStyle.dart';

class HomeScreenDetailRedeemScreen extends GetView<HomeScreenDetailRedeemScreenController>{
  const HomeScreenDetailRedeemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(220),
            child: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
                      image: DecorationImage(image: NetworkImage(controller.promoModel.promoImageUrl),fit: BoxFit.cover,)
                    ),
                  ),
                  Positioned(
                      top: 20,
                      left: 20,
                      child: GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: iconContainer(icon: Icons.arrow_back))),
                  Positioned(
                      top: 20,
                      right: 20,
                      child: iconContainer(icon: Icons.favorite)),
                ],
              ),
            )
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.promoModel.promoImagesModel.length,
                        itemBuilder: (BuildContext context,int index){
                          return customRowCards(controller.promoModel.promoImagesModel[index].imageUrl);
                        }
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star,color: AppColors.iconColor,size: 20),
                      const SizedBox(width: 6),
                      Text('4.5',style: bodyMediumMedium(color: AppColors.primary,fontSize: 20),),
                      Text('(300)',style: heading1(color: AppColors.a4Color,fontSize: 14),),
                      const Padding(
                        padding: EdgeInsets.only(left:21,right: 6),
                        child: Icon(Icons.remove_red_eye_outlined,size: 20),
                      ),
                      Expanded(child: Text('100',style: heading1SemiBold(color: AppColors.darkPink,fontSize: 14),)),
                      GestureDetector(
                          onTap: (){
                            controller.makePhoneCall(controller.promoModel.userDetailModel.phone);
                          },
                          child: callWidget(icon: 'call_icon.png', text: 'Call'))
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      Expanded(child: Text(controller.promoModel.productName,style: headingBold(color: AppColors.primary),)),
                      Text('\$${controller.promoModel.price}',style: headingBold(color: AppColors.primary),),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(controller.promoModel.userDetailModel.businessName,style:bodyMediumMedium(color: AppColors.primary,fontSize: 15),),
                  const SizedBox(height: 13,),
                  informationWidget(),
                  const SizedBox(height: 13,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for(int i=0;i<controller.promoModel.socialLinks.length;i++)
                        socialMediaIconWidget(platform: controller.promoModel.socialLinks[i].platform,onPressed: (){
                          controller.openSocialLink(controller.promoModel.socialLinks[i].url);
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13,),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,bottom: 8),
                    child: Text('Promo Code',style: headingBold(color: AppColors.primary,fontSize: 14),),
                  ),
                  primaryButton(color: AppColors.darkPink,buttonText: controller.promoModel.promoCode,textColor: AppColors.white,fontSize: 24,onPressed: (){
                   // customDialog('fur50');
                  }),

                ],
              ),
            ),
          ),
        ));
  }
  Widget socialMediaIconWidget({onPressed, required String platform}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        height: 36,
        width: 59,
        decoration: BoxDecoration(
          color:AppColors.textFieldBackground,
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
        ),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: imageIcon(img:
            platform=='facebook'?'facebook_icon.png':
            platform=='instagram'?'instagram.png':
            platform=='youtube'?'yotube_icon.png':
            platform=='pinterest'?'pinterest.png':
            platform=='twitter'?'twitter_icon.png':
            platform=='reddit'?'reddit.png':
            platform=='quora'?'quora.png':
            platform=='linkedin'?'linkedin_icon.png':
            platform=='whatsapp'?'whatsapp_icon.png':'empty.png'
            ),
          ),
        ),
      ),
    );
  }

  Widget customRowCards(String image) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            image,
            height: 103,
            width: 104,
            fit: BoxFit.cover,
          )),
    );
  }

  Widget iconContainer({String? image="", IconData? icon}){
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

  Widget callWidget({required String icon, required String text}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.darkPink,width: 1),
      ),
      child: Row(
        children: [
          imageIcon(img: icon,size: 20),
          const SizedBox(width: 7,),
          Text(text,style: heading1SemiBold(color: AppColors.darkPink,fontSize: 20),)
        ],
      ),
    );
  }

  Widget informationWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description',style: headingBold(color: AppColors.primary),),
        const SizedBox(height: 7),
        Text(controller.promoModel.description,style:bodyMediumMedium(color: AppColors.primary,fontSize: 15)),
        const SizedBox(height: 30,),
      ],
    );
  }

  Widget informationRowWidget({required String name, required String value}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: Text(name,style:heading1SemiBold(color: AppColors.primary,fontSize: 14),)),
          Expanded(child: Text(value,style: heading1(color: AppColors.a4Color,fontSize: 14,fontWeight: FontWeight.w400),)),
        ],
      ),
    );
  }

}