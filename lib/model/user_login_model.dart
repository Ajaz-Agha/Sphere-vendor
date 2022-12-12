import 'package:sphere_vendor/model/user_detail_model.dart';

class UserLoginModel{
  String requestErrorMessage = "";
  String token = "";
  UserDetailModel userDetailModel=UserDetailModel.empty();
  UserLoginModel.empty();

  UserLoginModel.fromJSON(Map<String, dynamic> json,String statusDescription){
    token = json['token'] ?? "";
    userDetailModel=UserDetailModel.fromJSON(json["user"]?? Map());
    requestErrorMessage=statusDescription;
  }
  UserLoginModel.fromSessionData(Map<String, dynamic> json){
    token = json['token'] ?? "";
    userDetailModel=UserDetailModel.fromJSON(json["user"]?? Map());
  }

  Map<String, dynamic> toJsonForSession() {
    Map<String, dynamic> json = {
      "token": token,
      "user": userDetailModel.toJson()

    };
    return json;
  }
  Map<String, dynamic> toJsonUpdateForSession() {
    Map<String, dynamic> json = {
      "token": token,
      "user": userDetailModel.toJson()

    };
    return json;
  }
  UserLoginModel.fromJSONForUpdate(Map<String, dynamic> json,String statusDescription){
    userDetailModel=UserDetailModel.fromJSON(json);
    requestErrorMessage=statusDescription;
  }
  Map<String, dynamic> toJsonForUpdate(){
    Map <String, dynamic> json = {
      "user": userDetailModel.toJsonForUpdate()
    };
    return json["user"];
  }

  @override
  String toString() {
    return 'UserLoginModel{requestErrorMessage: $requestErrorMessage, token: $token, userDetailModel: $userDetailModel}';
  }
}