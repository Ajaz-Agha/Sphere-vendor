class ForgotPasswordModel{
  String email='';
  int code=-1;
  String responseMessage='';

  ForgotPasswordModel();

  ForgotPasswordModel.fromJSON(Map<String, dynamic> json,String statusDescription){
    email = json['email'] ?? "";
    code=json["code"]??-1;
    responseMessage=statusDescription;

  }

  @override
  String toString() {
    return 'ForgotPasswordModel{email: $email, code: $code}';
  }
}