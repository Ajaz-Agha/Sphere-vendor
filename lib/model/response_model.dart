class ResponseModel {
  int statusCode= -1;
  String statusDescription = "";
  dynamic data;

  ResponseModel();
  ResponseModel.named({required this.statusCode, required this.statusDescription, this.data});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode =(json["success"] != null && !json["success"])?1:0;
    statusDescription =  json["message"]??"";
    if(statusDescription == "The given data was invalid."){
      Map<String,dynamic> error = json["errors"];
      error.forEach((key, value) {
        if(value != null && value.length > 0){
          data = value[0];
        }else{
          data = value;
        }
      });
    }else{
      data = json["data"];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': statusCode,
      'message': statusDescription,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'ResponseModel{statusCode: $statusCode, statusDescription: $statusDescription, data: $data}';
  }
}
