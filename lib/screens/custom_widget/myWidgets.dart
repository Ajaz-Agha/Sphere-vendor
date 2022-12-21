import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/screens/custom_widget/textStyle.dart';
import 'package:sphere_vendor/utils/app_constants.dart';

import '../../utils/app_colors.dart';

Widget primaryButton(
    {String? buttonText = "",
      dynamic onPressed,
      bool isOutlined = false,
      bool isMargin = true,
      Color? color = Colors.black,
      Color? textColor,
      bool isGradient = true,
      double radius = 10,
      double height = 52,
      double? width,
      bool isWidthNull = false,
      Widget? widget,
      double? fontSize,
      bool isBackgroundNull = false}) {
  return Container(
    width: isWidthNull ? null : width ?? double.infinity,
    height: height,
    margin: isMargin ? const EdgeInsets.only(left: 24, right: 24) : null,
    decoration: isBackgroundNull || isOutlined
        ? null
        : BoxDecoration(
        borderRadius: BorderRadius.circular(radius), color: color),
    child: MaterialButton(
      elevation: 0,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      color: (isOutlined || isBackgroundNull) ? null : color,
      shape: isBackgroundNull
          ? null
          : RoundedRectangleBorder(
          side: BorderSide(
            width: isOutlined ? 1 : 0,
            style: isOutlined ? BorderStyle.solid : BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(radius)),
      child: widget ??
          Text(
            buttonText!,
            style: bodyMediumMedium(
                fontSize: fontSize,
                color: (isBackgroundNull || isOutlined)
                    ? (color)
                    : textColor ?? AppColors.black),
          ),
    ),
  );
}


Widget imageIcon({required String img, Color? color, double? size = 24}) {
  if (color == null) {
    return Image.asset(
      Img.get(img),
      width: size,
      height: size,
    );
  }

  return ImageIcon(
    AssetImage(Img.get(img)),
    size: size,
    color: color,
  );
}
/*Load image from folder assets/images/
 */
class Img {
  static String get(String? name){
    return 'assets/images/$name';
  }
}

PreferredSize customAppBar({String? tileText="",String? tileText2="",String? description="",String? image}){
  return PreferredSize(
      preferredSize:const Size.fromHeight(220),
      child: SafeArea(
          child: Stack(
            children: [
              imageIcon(img: 'splash_screen_bg2.png',size: 150,color: AppColors.black),
              SizedBox(
                  height: 220,
                  child: tileText!="" && description!=""?
                  Padding(
                    padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tileText!,style: bodyMediumMedium(color: AppColors.white,fontSize: 30),),
                        Text(tileText2!,style: heading1SemiBold(color: AppColors.white,fontSize: 30),),
                        const SizedBox(height: 14,),
                        Expanded(child: Text(description!,style:heading1(color: AppColors.white,fontSize: 14)))
                      ],
                    ),
                  ):
                  Center(
                    child: imageIcon(img: image!,size: 200),
                  )
              ),
            ],
          )
      ));
}

Widget customText({required String heading, required String description}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(Icons.arrow_back,color: AppColors.primary,size: 27,),
      const SizedBox(height: 15,),
      Text(heading,style: heading1(color: AppColors.primary,fontSize: 30),),
      const SizedBox(height: 11),
      Text(description,style: heading1(color: AppColors.primary,fontSize: 16),)
    ],
  );
}

Widget customTextField(
    {String hintText = "",
      bool enabled = true,
      bool isAllProduct = false,
      bool isPassword = false,
      bool showpassword = false,
      Widget? suffixIcon,
      Widget? prefexIcon,
      Color color = Colors.white,
      int? maxLength,
      TextInputType? keyBoardType,
      double? fontSize,
      dynamic onChanged,
      bool readOnly=false,
      Color? fillColor,
      double radius = 8,
      TextEditingController? controller,
      bool isMultiLine = false,
      FocusNode? focusNode,
      double height = 52}) {
  return SizedBox(
    height: isMultiLine ? null : height,
    child: TextField(
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      controller: controller,
      obscureText: showpassword,
      textAlign: maxLength != null ? TextAlign.center : TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      maxLength: maxLength,
      keyboardType: keyBoardType,
      style: maxLength != null
          ? heading1SemiBold()
          : bodyMediumMedium(color: AppColors.black,fontSize: fontSize),
      obscuringCharacter: '*',
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        border: border(radius: radius),
        enabledBorder: border(radius: radius, isFocused: false),
        focusColor: AppColors.darkPink,
        focusedBorder: border(radius: radius),
        filled: true,
        counterText: "",
        suffixIcon: suffixIcon,
        prefixIcon: prefexIcon,
        prefixIconColor: AppColors.black,
        hintStyle: bodyMediumMedium(color: AppColors.lightGrey,fontSize: fontSize),
        hintText: hintText,
        fillColor: fillColor??AppColors.textFieldBackground,
      ),
      onChanged: (text) {
        if(onChanged!=null) {
          onChanged(text);
        }
      },
    ),
  );
}

InputBorder border({required double radius, bool isFocused = false}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(radius),
    ),
    borderSide: BorderSide(
      width: 1,
      color: isFocused ? AppColors.primary: AppColors.borderColor,
      style: BorderStyle.solid,
    ),
  );
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
                  Expanded(child: primaryButton(height: 40,color: AppColors.darkPink,radius: 9,buttonText: 'Yes',textColor: AppColors.white,fontSize: 18,onPressed: (){
                    Get.back();
                    Get.offNamed(kEditPromoScreen,arguments: promoModel);
                  })),
                ],
              )
            ],
          ),
        ),
      )
  );
}

Widget showEmptyListMessage(
    {required String message, double heightPercentage = 0.6}) {
  return SizedBox(
      height: Get.height * heightPercentage,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/empty_record.png",
                width: Get.width * 0.5),
            Text(
              message,
              style: const TextStyle(
                  color: Color(0xffe2e2e2),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ));
}



