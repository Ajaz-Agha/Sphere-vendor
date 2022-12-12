import 'package:sphere_vendor/model/category_model.dart';
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


}