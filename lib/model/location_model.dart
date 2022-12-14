class LocationModel{
  String name='';
  int id=-1;
  String address='';
  String latitude="";
  String longitude='';
  String createdAt='';
  int isDefault=-1;
  String responseMessage='';

  LocationModel.empty();

  LocationModel({required this.address,required this.latitude,required this.longitude});

  LocationModel.fromJson(Map<String,dynamic> json){
    name= json["name"]??"";
    id= json["id"]??-1;
    createdAt= json["created_at"]??"";
    address= json["address"]??"";
    latitude= json["latitude"]??"";
    longitude= json["longitude"]??"";
    isDefault=json["is_default"]??-1;
  }

 /* Map<String, String> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,

    };
  }*/

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'is_default':isDefault,

    };
  }


  @override
  String toString() {
    return 'LocationModel{name: $name, id: $id, address: $address, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, isDefault: $isDefault, responseMessage: $responseMessage}';
  }
}