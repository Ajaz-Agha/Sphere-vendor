import 'dart:developer';
import 'dart:io';

import 'package:sphere_vendor/model/promo_images_model.dart';
import 'package:sphere_vendor/model/user_detail_model.dart';

import 'category_model.dart';
import 'link_model.dart';

class PromoModel{
  int id=-1;
  String productName='';
  String price='';
  String discount='';
  String startDate='';
  String endDate='';
  String description='';
  String address='';
  String latitude='';
  String longitude='';
  String promoCode='';
  String status='';
  String imageCover='';
  int categoryId=-1;
  String createdAt='';
  String updatedAt='';
  List<String> imagesName=[];
  List<File> images=[];
  List<SocialLinkModel> socialLinks=[];
  String promoImageUrl='';
  CategoryModel categoryModel=CategoryModel.empty();
  List<PromoImagesModel> promoImagesModel=[];
  UserDetailModel userDetailModel=UserDetailModel.empty();


  PromoModel(
      this.productName,
      this.price,
      this.discount,
      this.startDate,
      this.endDate,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      this.promoCode,
      this.status,
      this.imageCover,
      this.categoryId,
      this.images,
      this.socialLinks
     );
  PromoModel.forEdit(
      this.id,
      this.productName,
      this.price,
      this.discount,
      this.startDate,
      this.endDate,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      this.promoCode,
      this.imageCover,
      this.categoryId,
      this.images,
      this.socialLinks
      );

  String responseMessage='';

  PromoModel.empty();

  PromoModel.fromJson(Map<String,dynamic> json, String responseString){
    responseMessage=responseString;
    id=json['id']??-1;
    productName= json["product_name"]??"";
    price= json["price"].toString()??"";
    discount= json["discount"].toString()??"";
    startDate= json["start_date"]??"";
    endDate= json["end_date"]??"";
    address= json["address"]??"";
    latitude= json["latitude"]??"";
    longitude= json["longitude"]??"";
    promoCode= json["promo_code"]??"";
    categoryId=json["promo_category_id"]??-1;
    status=json["status"]??'';
    imageCover=json['image']??'';
    description=json["description"]??'';
    createdAt=json["created_at"]??'';
    updatedAt=json['updated_at']??'';
    description=json['description']??'';
    promoImageUrl=json["promo_image_url"]??'';
    for(var x in json["social_links"]??[]) {
      socialLinks.add(SocialLinkModel.fromJson(x));
    }
    categoryModel=CategoryModel.fromJson(json["promo_category"]??Map());
    for(var x in json["promo_images"]??[]) {
      promoImagesModel.add(PromoImagesModel.fromJson(x));
    }
    userDetailModel=UserDetailModel.fromJSON(json["user"]?? Map());
    /*for(var item in json["created_at"]){
      socialLinks.add(item);
    }*/


  }


  @override
  String toString() {
    return 'PromoModel{id: $id, productName: $productName, price: $price, discount: $discount, startDate: $startDate, endDate: $endDate, description: $description, address: $address, latitude: $latitude, longitude: $longitude, promoCode: $promoCode, status: $status, imageCover: $imageCover, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt, imagesName: $imagesName, images: $images, socialLinks: $socialLinks, promoImageUrl: $promoImageUrl, categoryModel: $categoryModel, promoImagesModel: $promoImagesModel, userDetailModel: $userDetailModel, responseMessage: $responseMessage}';
  }
}