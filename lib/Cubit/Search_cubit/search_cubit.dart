import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:threads/Models/user_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void searchUsers(String query) async {
    try {
      emit(SearchLoading());

      List<UserModel> users = [];

      final _user = await FirebaseFirestore.instance.collection('users').get();

      users = _user.docs
          .map((user) => UserModel.fromJson(user.data()))
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (users.isNotEmpty) {
        emit(SearchSuccess(users));
      } else {
        emit(SearchFailed('No users found.'));
      }
    } catch (e) {
      emit(SearchFailed(e.toString()));
    }
  }
}
