class UserModel {
  String id;
  String name;
  String photo;


  UserModel(
      {required this.name, required this.id, required this.photo});

factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      name: json['name'],
      photo: json['photo'],
      id: json['userId'],
    );

}
Map<String, dynamic> toJson(){
  return {
    'name': name,
    'photo': photo,
    'userId': id,
  };
}

}