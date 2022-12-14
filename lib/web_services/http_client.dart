import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/model/user_login_model.dart';
import '../model/response_model.dart';
import '../utils/user_session_management.dart';

class HTTPClient{

  HTTPClient._internal();
  factory HTTPClient(){
    return _instance;
  }
  static const int _requestTimeOut = 15;
  static final HTTPClient _instance = HTTPClient._internal();

  Future<ResponseModel> postRequest(
      {required String url,
        dynamic requestBody,
        bool needHeaders: true}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: (needHeaders) ? await _getHeaders() : {},
        body: requestBody,
      ).timeout(const Duration(seconds: _requestTimeOut));
      ResponseModel responseModel =
      ResponseModel.fromJson(json.decode(response.body));
      return responseModel;
    } on TimeoutException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 408, statusDescription: "Request TimeOut", data: ""));
    } on SocketException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 400, statusDescription: "Bad Request", data: ""));
    } catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 500, statusDescription: "Server Error", data: ""));
    }
  }



  Future<ResponseModel> getRequest(
      {required String url, bool needHeaders: true}) async {
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: (needHeaders) ? await _getHeaders() : {},
      ).timeout(Duration(minutes: 5));

      ResponseModel responseModel =
      ResponseModel.fromJson(jsonDecode(response.body));
      return responseModel;
    } on TimeoutException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 408, statusDescription: "Request TimeOut", data: ""));
    } on SocketException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 400, statusDescription: "Bad Request", data: ""));
    } catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 500, statusDescription: "Server Error", data: ""));
    }
  }

  Future<ResponseModel> postMultipartRequest({required String url, required UserLoginModel userLoginModel, required String imgPath,required String coverPath}) async {
    try {
      Map<String, String> customHeader = await _getHeaders();
      if (customHeader.isNotEmpty && customHeader.entries.first.value.isNotEmpty) {
        http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

        request.headers.addAll(customHeader);
        request.fields['first_name'] = userLoginModel.userDetailModel.firstName;
        request.fields['last_name'] = userLoginModel.userDetailModel.lastName;
        request.fields['phone'] = userLoginModel.userDetailModel.phone;
        request.fields['description'] = userLoginModel.userDetailModel.description;
        if(imgPath!='') {

          request.files.add(await http.MultipartFile.fromPath('profile_image', imgPath));
        }
        if(coverPath!=''){
          request.files.add(await http.MultipartFile.fromPath('cover_image', coverPath));
        }

        http.StreamedResponse streamedResponse=await request.send();
        http.Response httpResponse=await http.Response.fromStream(streamedResponse);
        ResponseModel response=ResponseModel.fromJson(jsonDecode(httpResponse.body));
        return Future.value(response);
      }else{
        return Future.value(ResponseModel.named(statusCode:404, statusDescription:"Client authentication failed", data:""));
      }

    } on TimeoutException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 408,
          statusDescription: "Request TimeOut",
          data: "Request TimeOut"));
    } on SocketException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 400,
          statusDescription: "Bad Request",
          data: "Bad Request"));
    } catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 500,
          statusDescription: "Server Error",
          data: "Server Error"));
    }
  }
  Future<ResponseModel> postMultipartRequestForAddPromo({required String url, required PromoModel promoModel}) async {
    try {
      Map<String, String> customHeader = await _getHeaders();
      if (customHeader.isNotEmpty && customHeader.entries.first.value.isNotEmpty) {
        http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

        request.headers.addAll(customHeader);
        request.fields['product_name'] = promoModel.productName;
        request.fields['price'] = promoModel.price;
        request.fields['discount'] = promoModel.discount;
        request.fields['start_date'] = promoModel.startDate;
        request.fields['end_date'] = promoModel.endDate;
        request.fields['description'] = promoModel.description;
        request.fields['address'] = promoModel.address;
        request.fields['latitude'] = promoModel.latitude;
        request.fields['longitude'] = promoModel.longitude;
        request.fields['promo_code'] = promoModel.promoCode;
        request.fields['status'] = promoModel.status;
        request.fields['categoty_id'] = promoModel.categoryId.toString();
        if(promoModel.socialLinks.isNotEmpty){
          for(int i=0;i<promoModel.socialLinks.length;i++){
            if(promoModel.socialLinks[i].url!=''&& promoModel.socialLinks[i].platform!=''){
              request.fields['social_links[$i][link]'] = promoModel.socialLinks[i].url;
              request.fields['social_links[$i][platform]'] = promoModel.socialLinks[i].platform;
            }
          }
        }

        request.files.add(await http.MultipartFile.fromPath('image', promoModel.imageCover));

        for (int i = 0; i < promoModel.images.length; i++) {
          request.files.add(await http.MultipartFile.fromPath('images[$i]', promoModel.images[i].path));
        }
        http.StreamedResponse streamedResponse=await request.send();
        http.Response httpResponse=await http.Response.fromStream(streamedResponse);
        ResponseModel response=ResponseModel.fromJson(jsonDecode(httpResponse.body));
        return Future.value(response);
      }else{
        return Future.value(ResponseModel.named(statusCode:404, statusDescription:"Client authentication failed", data:""));
      }

    } on TimeoutException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 408,
          statusDescription: "Request TimeOut",
          data: "Request TimeOut"));
    } on SocketException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 400,
          statusDescription: "Bad Request",
          data: "Bad Request"));
    } catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 500,
          statusDescription: "Server Error",
          data: "Server Error"));
    }
  }

  Future<ResponseModel> postMultipartRequestForEditPromo({required String url, required PromoModel promoModel}) async {
    try {
      Map<String, String> customHeader = await _getHeaders();
      if (customHeader.isNotEmpty && customHeader.entries.first.value.isNotEmpty) {
        http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(customHeader);
        request.fields['promo_id'] = promoModel.id.toString();
        request.fields['product_name'] = promoModel.productName;
        request.fields['price'] = promoModel.price;
        request.fields['discount'] = promoModel.discount;
        request.fields['start_date'] = promoModel.startDate;
        request.fields['end_date'] = promoModel.endDate;
        request.fields['description'] = promoModel.description;
        request.fields['address'] = promoModel.address;
        request.fields['latitude'] = promoModel.latitude;
        request.fields['longitude'] = promoModel.longitude;
        request.fields['category_id'] = promoModel.categoryId.toString();
        if(promoModel.socialLinks.isNotEmpty){
          for(int i=0;i<promoModel.socialLinks.length;i++){
            if(promoModel.socialLinks[i].url!=''&& promoModel.socialLinks[i].platform!=''){
              request.fields['social_links[$i][link]'] = promoModel.socialLinks[i].url;
              request.fields['social_links[$i][platform]'] = promoModel.socialLinks[i].platform;
            }
          }
        }
        if(promoModel.imageCover!='') {
          request.files.add(await http.MultipartFile.fromPath(
              'image', promoModel.imageCover));
        }

        for (int i = 0; i < promoModel.images.length; i++) {
          request.files.add(await http.MultipartFile.fromPath('images[$i]', promoModel.images[i].path));
        }
        http.StreamedResponse streamedResponse=await request.send();
        http.Response httpResponse=await http.Response.fromStream(streamedResponse);
        ResponseModel response=ResponseModel.fromJson(jsonDecode(httpResponse.body));
        return Future.value(response);
      }else{
        return Future.value(ResponseModel.named(statusCode:404, statusDescription:"Client authentication failed", data:""));
      }

    } on TimeoutException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 408,
          statusDescription: "Request TimeOut",
          data: "Request TimeOut"));
    } on SocketException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 400,
          statusDescription: "Bad Request",
          data: "Bad Request"));
    } catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 500,
          statusDescription: "Server Error",
          data: "Server Error"));
    }
  }



  Future<ResponseModel> getRequestWithOutHeader({required String url}) async {
    try {
      http.Response response =
      await http.get(Uri.parse(url)).timeout(Duration(seconds: _requestTimeOut));
      ResponseModel responseModel = ResponseModel();
      if (response != null &&
          response.body != null &&
          response.body.length > 4) {
        responseModel.statusCode = response.statusCode;
        responseModel.statusDescription = "Success";
        responseModel.data = response.body;
      }

      return responseModel;
    } on TimeoutException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 408, statusDescription: "Request TimeOut", data: ""));
    } on SocketException catch (e) {
      return Future.value(ResponseModel.named(
          statusCode: 400, statusDescription: "Bad Request", data: ""));
    } catch (_) {
      return Future.value(ResponseModel.named(
          statusCode: 500, statusDescription: "Server Error", data: ""));
    }
  }

  Future<Map<String, String>> _getHeaders()async{
    UserLoginModel userLoginModel=await UserSession().getUserLoginModel();
    return {
      'Accept': 'application/json',
      "Authorization":'Bearer ${userLoginModel.token}',
    };
  }

}