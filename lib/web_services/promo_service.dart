
import 'dart:developer';

import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/web_services/web_url.dart';
import '../model/response_model.dart';
import '../utils/app_constants.dart';
import 'http_client.dart';

class PromoService{

  static final PromoService _instance = PromoService._internal();
  PromoService._internal(){
    _httpClient = HTTPClient();
  }
  factory PromoService()=>_instance;

  late HTTPClient _httpClient;


  Future<PromoModel> addPromo({required PromoModel promoModel}) async {
    PromoModel pModel = PromoModel.empty();
    ResponseModel responseModel = await _httpClient.postMultipartRequestForAddPromo(
        url: kAddPromoURL, promoModel: promoModel);

    if (responseModel.statusCode == 408) {
      pModel.responseMessage=kPoorInternetConnection;
      return pModel;
    } else if (responseModel.statusCode == 400 ||
        responseModel.statusCode == 500) {
      pModel.responseMessage=kNetworkError;
      return pModel;
    } else if (responseModel.statusCode == 602) {
      pModel.responseMessage=("$kMissingParameters\n${responseModel.data}");
      return pModel;
    } else if (responseModel.statusCode == 607) {
      pModel.responseMessage=("${responseModel.statusDescription}\n${responseModel.data}");
      return pModel;
    } else if (responseModel.data != null &&
        responseModel.data.length > 0 &&
        responseModel.statusDescription == "Promo added successfully") {
      pModel = PromoModel.fromJson(responseModel.data,responseModel.statusDescription);
      return pModel;
    }
    else{

      pModel.responseMessage=responseModel.statusDescription;
      return pModel;
    }
  }

  Future<PromoModel> editPromo({required PromoModel promoModel}) async {
    PromoModel pModel = PromoModel.empty();
    ResponseModel responseModel = await _httpClient.postMultipartRequestForEditPromo(
        url: kEditPromoURL, promoModel: promoModel);

    if (responseModel.statusCode == 408) {
      pModel.responseMessage=kPoorInternetConnection;
      return pModel;
    } else if (responseModel.statusCode == 400 ||
        responseModel.statusCode == 500) {
      pModel.responseMessage=kNetworkError;
      return pModel;
    } else if (responseModel.statusCode == 602) {
      pModel.responseMessage=("$kMissingParameters\n${responseModel.data}");
      return pModel;
    } else if (responseModel.statusCode == 607) {
      pModel.responseMessage=("${responseModel.statusDescription}\n${responseModel.data}");
      return pModel;
    } else if (responseModel.data != null &&
        responseModel.data.length > 0 &&
        responseModel.statusDescription == "Promo updated") {
      pModel = PromoModel.fromJson(responseModel.data,responseModel.statusDescription);
      return pModel;
    }
    else{

      pModel.responseMessage=responseModel.statusDescription;
      return pModel;
    }
  }

  Future<List<PromoModel>> getPromo({String categoryId='',String status=''})async{
    List<PromoModel> promoModel = [];
    Map<String,String> requestBody = {
      "category_id":categoryId,
      "status":status
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kGetPromoURL,
        requestBody: requestBody,needHeaders: true);
    if(responseModel.statusDescription=="Promos found"  && responseModel.data != null && responseModel.data.length > 0){
      for(var x in responseModel.data['data']){
        promoModel.add(PromoModel.fromJson(x,responseModel.statusDescription));
      }
      return promoModel;
    }
    return promoModel;
  }

  Future<String> updatePromoStatus({required int promoId,required String status})async{
    Map<String,String> requestBody = {
      "promo_id":promoId.toString(),
      "status":status
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kChangePromoStatusURL,
        requestBody: requestBody,needHeaders: true);
    if(responseModel.statusDescription=="status changed"){
      return responseModel.statusDescription;
    }
    return responseModel.statusDescription;
  }


  Future<String> deletePromo({required int promoId})async{
    Map<String,String> requestBody = {
      "id":promoId.toString(),
    };
    ResponseModel responseModel = await _httpClient.postRequest(url: kDeletePromoUrl,
        requestBody: requestBody,needHeaders: true);
    return responseModel.statusDescription;
  }

}