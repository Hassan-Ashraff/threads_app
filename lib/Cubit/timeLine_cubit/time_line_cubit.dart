import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threads/Models/post_model.dart';
import 'package:threads/Models/user_model.dart';

part 'time_line_state.dart';

class TimeLineCubit extends Cubit<TimeLineState> {
  TimeLineCubit() : super(TimeLineInitial());

  Future<void> getTimeLine() async {
    try {
      emit(TimeLineLoading());
      final posts = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      List<PostModel> listOfPosts = [];
      List<PostModel> myPosts = [];
      //get user data for each post's authorId
      for (final post in posts.docs) {
        final authorId = post.data()['author'];
        if (authorId != null) {
          final fetchedUser = await FirebaseFirestore.instance
              .collection('users')
              .where('userId', isEqualTo: authorId)
              .get();

          if (fetchedUser.docs.isNotEmpty) {
            final user = UserModel.fromJson(fetchedUser.docs.first.data());
            listOfPosts.add(PostModel.fromJson(post.data(), user));
          }
        }
      }

      for (int i = 0; i < listOfPosts.length; i++) {
        if (listOfPosts[i].author == FirebaseAuth.instance.currentUser!.uid) {
          myPosts.add(listOfPosts[i]);
        }
      }
      emit(TimeLineSuccess(listOfPosts, myPosts));
    } catch (e) {
      emit(TimeLineFailed(e.toString()));
    }
  }
}
