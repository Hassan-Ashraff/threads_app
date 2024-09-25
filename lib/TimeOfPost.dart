class TimeOfPosts{
  String formatTimeDifference(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''}';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes != 1 ? 's' : ''}';
    } else {
      final hours = difference.inHours;
      return '$hours hour${hours != 1 ? 's' : ''}';
    }
  }

}