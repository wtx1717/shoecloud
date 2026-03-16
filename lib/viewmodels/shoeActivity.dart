/// 运动记录简略信息模型 (对应 activities.json 中的项)
class ShoeActivity {
  String activityId;
  String syncTime;
  String startTime;
  double distanceKm;
  double durationS;
  String jsonUrl;
  String fitUrl;

  ShoeActivity({
    required this.activityId,
    required this.syncTime,
    required this.startTime,
    required this.distanceKm,
    required this.durationS,
    required this.jsonUrl,
    required this.fitUrl,
  });

  factory ShoeActivity.formJSON(Map<String, dynamic> json) {
    return ShoeActivity(
      activityId: json["activity_id"]?.toString() ?? "",
      syncTime: json["sync_time"] ?? "",
      startTime: json["start_time"] ?? "",
      distanceKm: (json["distance_km"] is num)
          ? json["distance_km"].toDouble()
          : 0.0,
      durationS: (json["duration_s"] is num)
          ? json["duration_s"].toDouble()
          : 0.0,
      jsonUrl: json["json_url"] ?? "",
      fitUrl: json["fit_url"] ?? "",
    );
  }
}
