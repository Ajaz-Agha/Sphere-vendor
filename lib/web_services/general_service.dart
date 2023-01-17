import 'package:sphere_vendor/model/category_model.dart';
import 'package:sphere_vendor/model/notification_model.dart';
import 'package:sphere_vendor/web_services/web_url.dart';
import '../model/response_model.dart';
import 'http_client.dart';

class GeneralService{

  static final GeneralService _instance = GeneralService._internal();
  GeneralService._internal(){
    _httpClient = HTTPClient();
  }
  factory GeneralService()=>_instance;

  late HTTPClient _httpClient;

  Future<dynamic> getCategory()async{
    List<CategoryModel> category = <CategoryModel>[];
    ResponseModel responseModel = await _httpClient.getRequest(
      url: kGetCategoryURL);
    if (responseModel.statusDescription.isNotEmpty &&
        responseModel.statusDescription == "Categories found" &&
        responseModel.data != null
        && responseModel.data.length > 0) {
      List categoryList = responseModel.data;
      for (int i = 0; i < categoryList.length; i++) {
        category.add(CategoryModel.fromJson(categoryList[i]));
      }

    }else{
      return responseModel.statusDescription;
    }
    return category;
  }

  Future<dynamic> getNotification()async{
    List<NotificationModel> notifications = <NotificationModel>[];
    ResponseModel responseModel = await _httpClient.getRequest(
        url: kGetNotificationsURL);
    if (responseModel.statusDescription.isNotEmpty &&
        responseModel.statusDescription == "Notifications found" &&
        responseModel.data != null
        && responseModel.data.length > 0) {
      List notificationList = responseModel.data['data'];
      for (int i = 0; i < notificationList.length; i++) {
        notifications.add(NotificationModel.fromJson(notificationList[i],responseModel.statusDescription));
      }
    }else{
      return responseModel.statusDescription;
    }
    return notifications;
  }

  Future<dynamic> getVendorsCategory()async{
    List<CategoryModel> category = <CategoryModel>[];
    ResponseModel responseModel = await _httpClient.getRequest(
        url: kGetVendorCategoryURL);
    if (responseModel.statusDescription.isNotEmpty &&
        responseModel.statusDescription == "Categories found" &&
        responseModel.data != null
        && responseModel.data.length > 0) {
      List categoryList = responseModel.data;
      for (int i = 0; i < categoryList.length; i++) {
        category.add(CategoryModel.fromJson(categoryList[i]));
      }

    }else{
      return responseModel.statusDescription;
    }
    return category;
  }


}