class PromoImagesModel{
  int id=-1;
  String image='';
  String imageUrl='';
  String createdAt='';

PromoImagesModel.empty();

  PromoImagesModel.fromJson(Map<String, dynamic> json){
  id=json['id']??-1;
  image=json['image']??'';
  imageUrl=json["promo_image_url"]??'';
  createdAt=json["created_at"]??"";
  }

  @override
  String toString() {
    return 'PromoImagesModel{id: $id, image: $image, imageUrl: $imageUrl, createdAt: $createdAt}';
  }
}