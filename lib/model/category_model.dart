class CategoryModel{
  String name='';
  int id=-1;
  String createdAt='';
  String responseMessage='';

  CategoryModel.empty();

  CategoryModel(this.name, this.id);

  CategoryModel.fromJson(Map<String,dynamic> json){
    name= json["name"]??"";
    id= json["id"]??-1;
    createdAt= json["created_at"]??"";

  }

  @override
  String toString() {
    return 'CategoryModel{name: $name, id: $id, createdAt: $createdAt, responseMessage: $responseMessage}';
  }
}