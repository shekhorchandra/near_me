class TimeFormatter {
  static String timeAgo(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime).toLocal();
      final now = DateTime.now();

      final diff = now.difference(dateTime);

      if (diff.inSeconds < 60) {
        return "${diff.inSeconds}s ago";
      } else if (diff.inMinutes < 60) {
        return "${diff.inMinutes}m ago";
      } else if (diff.inHours < 24) {
        return "${diff.inHours}h ago";
      } else if (diff.inDays < 7) {
        return "${diff.inDays}d ago";
      } else {
        return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      }
    } catch (e) {
      return "";
    }
  }
}