import 'package:get/get.dart';
import 'package:sphere_vendor/model/promo_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenDetailRedeemScreenController extends GetxController{
  PromoModel promoModel=PromoModel.empty();

@override
  void onInit() {
   promoModel=Get.arguments;
    super.onInit();
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri(scheme: 'tel', path: url))) {
      await launchUrl(Uri(scheme: 'tel', path: url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openSocialLink(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}