import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_login_model.dart';


class UserSession{

  UserSession._internal();
  static final UserSession _instance = UserSession._internal();
  factory UserSession(){
    return _instance;
  }
  static const String USER_DATA = "USERDATA";
  static const String IS_LOGIN = "IS_LOGIN";
  static const String IS_REMEBER="IS_REMEMBER";


  Future<void> createSession({required UserLoginModel userLoginModel}) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString(USER_DATA,jsonEncode(userLoginModel.toJsonForSession()));
    preference.setBool(IS_LOGIN, true);
  }

  Future<void> updateSessionData(UserLoginModel userLoginModel) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString(USER_DATA,jsonEncode(userLoginModel.toJsonForSession()));
  }

  Future<UserLoginModel> getUserLoginModel() async{
    SharedPreferences preference = await SharedPreferences.getInstance();
    return UserLoginModel.fromSessionData(jsonDecode(preference.getString(USER_DATA)??'{}'));
  }

  Future<bool> isUserLoggedIn()async{
    final preference = await SharedPreferences.getInstance();
    return preference.getBool(IS_LOGIN)??false;
  }
  Future<void> isRememberMe(String email) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString(IS_REMEBER,email);
  }
  Future<String> getEmail() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return preference.getString(IS_REMEBER)??'';
  }

  Future<void> logOut()async{
    final preference = await SharedPreferences.getInstance();
    preference.clear();
    // preference.setBool(IS_LOGIN, false);
  }

}