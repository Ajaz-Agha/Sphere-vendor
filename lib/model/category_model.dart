class CategoryModel{
  String name='';
  int id=-1;
  String responseMessage='';

  CategoryModel.empty();

  CategoryModel(this.name, this.id);

  CategoryModel.fromJson(Map<String,dynamic> json){
    name= json["name"]??"";
    id= json["id"]??-1;

  }
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name':name,

    };
  }

  @override
  String toString() {
    return 'CategoryModel{name: $name, id: $id, responseMessage: $responseMessage}';
  }
}