import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  AddPostCubit() : super(AddPostInitial());

  late final TextEditingController controller = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addPost(BuildContext context, Uint8List? file) async {
    if (controller.text.isEmpty && (file == null || file.isEmpty)) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post can\'t be empty')),
      );
      return;
    }

    emit(AddPostLoading());
    try {
      String? imageUrl;
      if (file != null) {
        imageUrl = await uploadImageToStorage('ImagesOfPosts', file);
      } else {
        imageUrl = '';
      }

      await firestore.collection('posts').add({
        'content': controller.text,
        'author': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': DateTime.now().toString(),
        'imageUrl': imageUrl,
      });

      controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully')),
      );
      emit(AddPostSuccess());
    } catch (e) {
      emit(AddPostFailed('The error is: ' + e.toString()));
    }
  }

  Future<String> uploadImageToStorage(String folderName, Uint8List file) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child('${DateTime.now().millisecondsSinceEpoch}.png');

    // Upload the image file to Firebase Storage
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;

    // Get the download URL of the uploaded image
    return await snapshot.ref.getDownloadURL();
  }
}
