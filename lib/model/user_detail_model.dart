
import 'package:get/get.dart';
import 'package:sphere_vendor/model/category_model.dart';
import 'package:sphere_vendor/model/location_model.dart';

class UserDetailModel{
  String uAccEmail = "";
  String requestErrorMessage = "";
  String firstName='';
  String lastName='';
  String profileImage='';
  String profileImageUrl='';
  String coverImageUrl='';
  String coverImage='';
  String phone='';
  String longitude='';
  String latitude='';
  String role='';
  String createdAt='';
  String businessName='';
  String businessAddress='';
  String description='';
  int userId=-1;
  RxInt totalFav=0.obs;
  List<LocationModel> locationModelList=[];
  List<CategoryModel> listOfCategories=[];
  UserDetailModel.empty();

  UserDetailModel.fromJSON(Map<String, dynamic> json){
    uAccEmail = json['email'] ?? "";
    userId= json['id'] ?? -1;
    firstName= json['first_name'] ?? "";
    lastName= json['last_name'] ?? "";
    profileImage= json['profile_image'] ?? "";
    profileImageUrl= json['profile_image_url'] ?? "";
    coverImageUrl= json['cover_image_url'] ?? "";
    coverImage= json['cover_image'] ?? "";
    phone= json['phone'] ?? "";
    latitude= json['latitude'] ?? "";
    longitude= json['longitude'] ?? "";
    role=json["role"]??"";
    description=json["description"]??"";
    createdAt=json["created_at"]??"";
    businessName=json["business_name"]??'';
    totalFav.value=json["total_favorites"]??0;
    for(var x in json["locations"]??[]) {
      locationModelList.add(LocationModel.fromJson(x));
    }
    for(var x in json["categories"]??[]) {
      listOfCategories.add(CategoryModel.fromJson(x));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "email": uAccEmail,
      "id":  userId,
      "first_name": firstName,
      "last_name": lastName,
      "profile_image": profileImage,
      "profile_image_url": profileImageUrl,
      "cover_image":coverImage,
      "cover_image_url":coverImageUrl,
      "role": role,
      "phone": phone,
      "latitude": latitude,
      "longitude": longitude,
      "created_at":createdAt,
      "description": description,
      "business_name":businessName,
      "address":businessAddress,
      "locations":locationModelList,
      "categories":listOfCategories

    };
  }
  Map<String, dynamic> toJsonForUpdate() {
    Map<String, dynamic> userModel = {};

    userModel["first_name"]=firstName;
    userModel["last_name"]=lastName;
    userModel["profile_image"]=profileImage;
    userModel["cover_image"]=coverImage;
    userModel["phone"]=phone;
    return userModel;

  }

  @override
  String toString() {
    return 'UserDetailModel{uAccEmail: $uAccEmail, requestErrorMessage: $requestErrorMessage, firstName: $firstName, lastName: $lastName, profileImage: $profileImage, profileImageUrl: $profileImageUrl, coverImageUrl: $coverImageUrl, coverImage: $coverImage, phone: $phone, longitude: $longitude, latitude: $latitude, role: $role, createdAt: $createdAt, businessName: $businessName, businessAddress: $businessAddress, description: $description, userId: $userId, totalFav: $totalFav, locationModelList: $locationModelList, listOfCategories: $listOfCategories}';
  }
}