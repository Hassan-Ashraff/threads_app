part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

final class SearchInitial extends SearchState {}
final class SearchLoading extends SearchState {}
final class SearchSuccess extends SearchState {
  final List<UserModel> users;
  SearchSuccess(this.users);

}
final class SearchFailed extends SearchState {
  final String message;
  SearchFailed(this.message);
}

