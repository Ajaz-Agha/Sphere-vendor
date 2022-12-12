class UserRegisterModel{
  String userEmail ="";
  String userPassword = "";
  String userConfirmPassword = "";
  String business = "";
  String role="vendor";
  String response='';


  UserRegisterModel.empty();

  UserRegisterModel(
      {
        required this.userEmail,
        required this.userPassword,
        required this.userConfirmPassword,
        required this.business,
      });


  UserRegisterModel.fromJson(Map<String,dynamic> json){
    userEmail= json["email"]??"";
    userPassword= json["password"]??"";
    userConfirmPassword= json["confirm_password"]??"";
    business= json["business_name"]??"";
    role=json["role"]??"user";

  }

  Map<String,dynamic> toJson(){

    Map<String, dynamic> userModel = {};

    userModel["email"]=userEmail;
    userModel["password"]=userPassword;
    userModel["confirm_password"]=userConfirmPassword;
    userModel["role"]=role;
    userModel["business_name"]=business;
    return userModel;
  }

  @override
  String toString() {
    return 'UserRegisterModel{userEmail: $userEmail, userPassword: $userPassword, userConfirmPassword: $userConfirmPassword, business: $business, role: $role, response: $response}';
  }
}