import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import '../screens/custom_widget/custom_dialog.dart';
import '../screens/custom_widget/custom_proggress_dialog.dart';
import '../utils/app_constants.dart';
import '../utils/common_code.dart';
import '../web_services/verify_email.dart';

class EmailVerificationScreenController extends GetxController{

  String email='';
  RxString otpCode=''.obs;


  Future<bool> onWillPop() {
    Get.offNamed(kLoginScreen);
    return Future.value(false);
  }

  @override
  void onInit() {
   email=Get.arguments;
    super.onInit();
  }

  Future<void> onEmailVerify() async{
    if(otpCode.value!=''){
      ProgressDialog pd = ProgressDialog();
      pd.showDialog();
      if(await CommonCode().checkInternetAccess()) {
        String response = await  VerifyAccountService().verifyAccount(verifyCode: otpCode.value,email: email);
        pd.dismissDialog();
        if (response!='' && response=='Account activated successfully') {
          pd.dismissDialog();
          CustomDialogs().showMessageDialog(
            title: "Success",
            description: "Verified Successfully!",
            type: DialogType.SUCCES,
            onOkBtnPressed: () => Get.offNamed(kLoginScreen),
          );
        } else {
          pd.dismissDialog();
          otpCode.value='';
          CustomDialogs().showMessageDialog(
              title: "Alert", description: response, type: DialogType.ERROR);
        }
      } else{
        pd.dismissDialog();
        CustomDialogs().showMessageDialog(title: 'Alert',
            description: kInternetMsg,
            type: DialogType.ERROR);
      }
    }else{
      CustomDialogs().showMessageDialog(title: 'Alert',
          description: 'OTP Code is Empty',
          type: DialogType.ERROR);
    }



  }
}