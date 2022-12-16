import 'dart:developer';

import 'package:sphere_vendor/model/forgot_password_model.dart';
import 'package:sphere_vendor/model/location_model.dart';
import 'package:sphere_vendor/web_services/web_url.dart';
import '../model/response_model.dart';
import '../model/user_login_model.dart';
import '../model/user_register_model.dart';
import '../utils/app_constants.dart';
import 'http_client.dart';

class UserService{

  static final UserService _instance = UserService._internal();
  UserService._internal(){
    _httpClient = HTTPClient();
  }
  factory UserService()=>_instance;

  late HTTPClient _httpClient;

  Future<UserLoginModel> loginUser({required String password,String email="",required deviceToken})async{
    UserLoginModel userLoginModel = UserLoginModel.empty();
    Map<String,String> requestBody = {
      "email":email,
      "password":password,
      "device_id":deviceToken
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kLoginUserURL,
        requestBody: requestBody,needHeaders: false);
    if((responseModel.statusCode == 400 || responseModel.statusCode == 500 )){
      userLoginModel.requestErrorMessage = kNetworkError;
      return userLoginModel;
    }else if(responseModel.statusCode == 408){
      userLoginModel.requestErrorMessage = kPoorInternetConnection;
      return userLoginModel;
    }else if(( responseModel.statusCode == 606||responseModel.statusCode == 404) && responseModel.statusDescription.contains("Invalid Input")){
      userLoginModel.requestErrorMessage = "Invalid Username or Password!";
      return userLoginModel;
    }else if(responseModel.statusDescription=="Logged in successfully"  && responseModel.data != null && responseModel.data.length > 0){
      userLoginModel = UserLoginModel.fromJSON(responseModel.data,responseModel.statusDescription);
      return userLoginModel;

    }
    userLoginModel.requestErrorMessage = responseModel.statusDescription;
    return userLoginModel;
  }

  Future<UserRegisterModel> registerUser(UserRegisterModel userRegisterModel)async{
    Map<String,dynamic> requestBody = userRegisterModel.toJson();
    ResponseModel responseModel = await _httpClient.postRequest(url: kRegisterUserURL,
        requestBody: requestBody,needHeaders: false);
    if(responseModel.statusCode == 408){
      userRegisterModel.response=kPoorInternetConnection;
      return userRegisterModel;
    }else if(responseModel.statusCode == 400 || responseModel.statusCode == 500){
      userRegisterModel.response=kNetworkError;
      return userRegisterModel;
    }else if(responseModel.data != null && responseModel.data.length > 0
        && responseModel.statusDescription == "User has been created successfully"){
      userRegisterModel.response=responseModel.statusDescription;
      return userRegisterModel;
    }
    userRegisterModel.response=responseModel.statusDescription;
    return userRegisterModel;
  }


  Future<dynamic> updateProfile({required UserLoginModel userLoginModelForUpdate, required String imgPath,required String coverImagePath}) async {
    UserLoginModel userLoginModel = UserLoginModel.empty();
    ResponseModel responseModel=ResponseModel();
      responseModel = await _httpClient.postMultipartRequest(
        userLoginModel: userLoginModelForUpdate,
        url: kUpdateUserProfileURL,
        imgPath: imgPath,
        coverPath: coverImagePath
      );

    if (responseModel.statusCode == 408) {
      userLoginModel.requestErrorMessage=kPoorInternetConnection;
      return userLoginModel;
    } else if (responseModel.statusCode == 400 ||
        responseModel.statusCode == 500) {
      userLoginModel.requestErrorMessage=kNetworkError;
      return userLoginModel;
    } else if (responseModel.statusCode == 602) {
      userLoginModel.requestErrorMessage=("$kMissingParameters\n${responseModel.data}");
      return userLoginModel;
    } else if (responseModel.statusCode == 607) {
      userLoginModel.requestErrorMessage=("${responseModel.statusDescription}\n${responseModel.data}");
      return userLoginModel;
    } else if (responseModel.data != null &&
        responseModel.data.length > 0 &&
        responseModel.statusDescription == "Profile Updated successfully") {
      userLoginModel = UserLoginModel.fromJSONForUpdate(responseModel.data,responseModel.statusDescription);
      return userLoginModel;
    }
    else{

      userLoginModel.requestErrorMessage=responseModel.statusDescription;
      return userLoginModel;
    }
  }

  Future<ForgotPasswordModel> forgotPassword({required String email})async{
    ForgotPasswordModel forgotPasswordModel=ForgotPasswordModel();
    Map<String,String> requestBody = {
      "email":email,
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kForgotPasswordURL,
        requestBody: requestBody,needHeaders: false);
    if((responseModel.statusCode == 400 || responseModel.statusCode == 500 )){
      forgotPasswordModel.responseMessage= kNetworkError;
      return forgotPasswordModel;
    }else if(responseModel.statusCode == 408){
      forgotPasswordModel.responseMessage= kPoorInternetConnection;
      return forgotPasswordModel;
    }else if(responseModel.statusDescription=="Email sent successfully"  && responseModel.data != null && responseModel.data.length > 0){
      forgotPasswordModel =ForgotPasswordModel.fromJSON(responseModel.data,responseModel.statusDescription);
      return forgotPasswordModel;

    }
   return forgotPasswordModel;
  }

  Future<String> updatePassword({required String email,required String password,required String confirmPassword})async{
    Map<String,String> requestBody = {
      "email":email,
      'password':password,
      'confirm_password':confirmPassword
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kUpdatePasswordURL,
        requestBody: requestBody);
    if((responseModel.statusCode == 400 || responseModel.statusCode == 500 )){
      return kNetworkError;
    }else if(responseModel.statusCode == 408){
      return kPoorInternetConnection;
    }else if(responseModel.statusDescription=="Password has been changed successfully"){
      return responseModel.statusDescription;

    }
    return responseModel.statusDescription;
  }
  Future<String> changeOldPassword({required String email,required String password,required String confirmPassword,required String oldPassword})async{
    Map<String,String> requestBody = {
      "email":email,
      "old_password":oldPassword,
      'password':password,
      'confirm_password':confirmPassword
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kChangePasswordURL,
        requestBody: requestBody);
    if((responseModel.statusCode == 400 || responseModel.statusCode == 500 )){
      return kNetworkError;
    }else if(responseModel.statusCode == 408){
      return kPoorInternetConnection;
    }else if(responseModel.statusDescription=="Password has been changed successfully"){
      return responseModel.statusDescription;

    }
    return responseModel.statusDescription;
  }

  Future<String> userLogOut() async {
    ResponseModel responseModel = await _httpClient.postRequest(
        url: kLogOutURL);
    if (responseModel.statusDescription.isNotEmpty &&
        responseModel.statusDescription == "User logout successfully") {
      return responseModel.statusDescription;

    } else {
      return responseModel.statusDescription;
    }

  }

  Future<String> updateLocation({required LocationModel locationModel})async{
    Map<String,String> requestBody = {
      'latitude': locationModel.latitude,
      'longitude': locationModel.longitude,
      'address': locationModel.address,
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kUpdateLocationURL,
        requestBody: requestBody,needHeaders: true);
    if((responseModel.statusCode == 400 || responseModel.statusCode == 500 )){
      return kNetworkError;
    }else if(responseModel.statusCode == 408){
      return kPoorInternetConnection;
    }else if(responseModel.statusDescription=="Location Updated successfully"  && responseModel.data != null && responseModel.data.length > 0){
      return responseModel.statusDescription;

    }
    return responseModel.statusDescription;
  }

}