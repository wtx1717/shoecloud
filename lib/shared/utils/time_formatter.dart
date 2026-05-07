/// 提供时长与配速格式化等通用工具。
class TimeFormatter {
  static String formatDuration(int seconds) {
    if (seconds <= 0) {
      return '0s';
    }

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remain = seconds % 60;
    final parts = <String>[];

    if (hours > 0) {
      parts.add('${hours}h');
    }
    if (minutes > 0) {
      parts.add('${minutes}m');
    }
    if (remain > 0 || parts.isEmpty) {
      parts.add('${remain}s');
    }

    return parts.join(' ');
  }

  static String formatActivityDuration(double seconds) {
    final total = seconds.round();
    final minutes = total ~/ 60;
    final remain = total % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remain.toString().padLeft(2, '0')}';
  }

  static String formatPace({
    required double distanceKm,
    required double seconds,
  }) {
    if (distanceKm <= 0) {
      return '0\'00"';
    }

    final pace = (seconds / 60) / distanceKm;
    final minutes = pace.floor();
    final remain = ((pace - minutes) * 60).round();
    return '$minutes\'${remain.toString().padLeft(2, '0')}"';
  }
}
