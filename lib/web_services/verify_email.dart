import 'package:sphere_vendor/web_services/web_url.dart';
import '../model/response_model.dart';
import '../utils/app_constants.dart';
import 'http_client.dart';

class VerifyAccountService{

  static final VerifyAccountService _instance = VerifyAccountService._internal();
  VerifyAccountService._internal(){
    _httpClient = HTTPClient();
  }
  factory VerifyAccountService()=>_instance;

  late HTTPClient _httpClient;

  Future<String> verifyAccount({required String verifyCode,String email=""})async{
    Map<String,String> requestBody = {
      "email":email,
      "verification_code":verifyCode,
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kVerifyAccountURL,
        requestBody:requestBody,needHeaders: false);
    if((responseModel.statusCode == 400 || responseModel.statusCode == 500 )){
      return kNetworkError;
    }else if(responseModel.statusCode == 408){
      return kPoorInternetConnection;
    }else if(( responseModel.statusCode == 606||responseModel.statusCode == 404) && responseModel.statusDescription.contains("Invalid Input")){
      return "Invalid!";
    }else if(responseModel.data != null && responseModel.data.length > 0){
      return responseModel.statusDescription;

    }
    return responseModel.statusDescription;
  }


}