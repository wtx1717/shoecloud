class TimeUtils {
  /// 将秒转换为 [小时, 分钟, 秒] 的 Map
  static Map<String, int> decodeSeconds(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return {"h": h, "m": m, "s": s};
  }

  /// 格式化为：02:13:20
  static String formatToStandard(int seconds) {
    var time = decodeSeconds(seconds);
    return [
      time['h'],
      time['m'],
      time['s'],
    ].map((t) => t.toString().padLeft(2, '0')).join(':');
  }

  /// 格式化为：2小时13分20秒 (常用于跑步统计展示)
  static String formatToChinese(int seconds) {
    if (seconds <= 0) return "0秒";

    var time = decodeSeconds(seconds);
    String result = "";

    if (time['h']! > 0) result += "${time['h']}小时";
    if (time['m']! > 0) result += "${time['m']}分";
    if (time['s']! > 0 || result.isEmpty) result += "${time['s']}秒";

    return result;
  }
}
