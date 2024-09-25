part of 'time_line_cubit.dart';

@immutable
abstract class TimeLineState {}

final class TimeLineInitial extends TimeLineState {}
final class TimeLineLoading extends TimeLineState {}
final class TimeLineSuccess extends TimeLineState {
  final List<PostModel> posts;
  final List<PostModel> Myposts;

  TimeLineSuccess(this.posts, this.Myposts);
}

final class TimeLineFailed extends TimeLineState {
  final String message;
  TimeLineFailed(this.message);
}


