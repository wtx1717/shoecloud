/// 表示已绑定到跑鞋上的活动摘要模型。
class ShoeActivity {
  ShoeActivity({
    required this.activityId,
    required this.syncTime,
    required this.startTime,
    required this.distanceKm,
    required this.durationSeconds,
    required this.jsonUrl,
    required this.fitUrl,
  });

  final String activityId;
  final String syncTime;
  final String startTime;
  final double distanceKm;
  final double durationSeconds;
  final String jsonUrl;
  final String fitUrl;

  factory ShoeActivity.fromJson(Map<String, dynamic> json) {
    return ShoeActivity(
      activityId: json['activity_id']?.toString() ?? '',
      syncTime: json['sync_time']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      distanceKm: (json['distance_km'] is num)
          ? json['distance_km'].toDouble()
          : 0.0,
      durationSeconds: (json['duration_s'] is num)
          ? json['duration_s'].toDouble()
          : 0.0,
      jsonUrl: json['json_url']?.toString() ?? '',
      fitUrl: json['fit_url']?.toString() ?? '',
    );
  }
}
