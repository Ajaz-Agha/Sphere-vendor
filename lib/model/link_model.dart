class SocialLinkModel{
  String url='';
  int id=-1;
  String platform='';
  String createdAt='';

  SocialLinkModel({ required this.url,required this.platform});
  SocialLinkModel.empty();

  SocialLinkModel.fromJson(Map<String, dynamic> json){
    id=json['id']??'';
    url=json["link"]??'';
    platform=json["platform"]??'';
    createdAt=json["created_at"]??'';

  }

  @override
  String toString() {
    return 'SocialLinkModel{url: $url, id: $id, platform: $platform, createdAt: $createdAt}';
  }
}