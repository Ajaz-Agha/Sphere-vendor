import 'package:sphere_vendor/model/promo_model.dart';
import 'package:sphere_vendor/model/user_detail_model.dart';

class NotificationModel{
  int id=-1;
  String title='';
  String body='';
  String type='';
  String messageResponse='';
  String createdAt='';
  UserDetailModel userDetailModel=UserDetailModel.empty();
  PromoModel promoModel=PromoModel.empty();

  NotificationModel.empty();

  NotificationModel.fromJson(Map<String,dynamic> json, String responseString){
    messageResponse=responseString;
    id=json['id']??-1;
    title=json['title']??'';
    body=json['body']??'';
    type=json['type']??'';
    createdAt=json['craeted']??'';
    userDetailModel=UserDetailModel.fromJSON(json["sender"]?? Map());
    promoModel=PromoModel.fromJson(json['data']??Map(), responseString);


  }

  @override
  String toString() {
    return 'NotificationModel{id: $id, title: $title, body: $body, type: $type, messageResponse: $messageResponse, createdAt: $createdAt, userDetailModel: $userDetailModel, promoModel: $promoModel}';
  }
}