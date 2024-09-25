import 'package:threads/Models/user_model.dart';

class PostModel{
  final String author;
  final String content;
  final DateTime createdAt;
  final String imageUrl;
  final UserModel user;
  PostModel({required this.content,required this.author, required this.createdAt,  required this.imageUrl, required this.user});

  factory PostModel.fromJson(Map<String, dynamic> json,UserModel user) {
    return PostModel(
      author: json['author'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      imageUrl: json['imageUrl'],
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'user': user,
    };
  }

}