/// 跑鞋信息模型
class ShoeInfo {
  String shoeId;
  String shoeName;
  String brand;
  String nickname;
  double size;
  double purchasePrice;
  double retailPrice;
  String releaseDate;
  String imageUrl;
  String bindTime;
  bool isRetired;
  String category;
  List<String> features;
  ShoeStats stats;
  String activitiesLink;

  ShoeInfo({
    required this.shoeId,
    required this.shoeName,
    required this.brand,
    required this.nickname,
    required this.size,
    required this.purchasePrice,
    required this.retailPrice,
    required this.releaseDate,
    required this.imageUrl,
    required this.bindTime,
    required this.isRetired,
    required this.category,
    required this.features,
    required this.stats,
    required this.activitiesLink,
  });

  // 扩展一个工厂函数，符合你的命名习惯 formJSON
  factory ShoeInfo.formJSON(Map<String, dynamic> json) {
    return ShoeInfo(
      shoeId: json["shoe_id"]?.toString() ?? "",
      shoeName: json["shoe_name"] ?? "",
      brand: json["brand"] ?? "",
      nickname: json["nickname"] ?? "",
      size: (json["size"] is num) ? json["size"].toDouble() : 0.0,
      purchasePrice: (json["purchase_price"] is num)
          ? json["purchase_price"].toDouble()
          : 0.0,
      retailPrice: (json["retail_price"] is num)
          ? json["retail_price"].toDouble()
          : 0.0,
      releaseDate: json["release_date"] ?? "",
      imageUrl: json["image_url"] ?? "",
      bindTime: json["bind_time"] ?? "",
      isRetired: json["is_retired"] ?? false,
      category: json["category"] ?? "",
      features: List<String>.from(json["features"] ?? []),
      stats: ShoeStats.formJSON(json["stats"] ?? {}),
      activitiesLink: json["activities_link"] ?? "",
    );
  }
}

/// 跑鞋统计数据子模型
class ShoeStats {
  double totalMileage;
  int totalClimb;
  int totalDuration;
  int totalPlacesCount;
  int usageCount;
  double maxSingleDistance;
  int maxSingleDuration;

  ShoeStats({
    required this.totalMileage,
    required this.totalClimb,
    required this.totalDuration,
    required this.totalPlacesCount,
    required this.usageCount,
    required this.maxSingleDistance,
    required this.maxSingleDuration,
  });

  factory ShoeStats.formJSON(Map<String, dynamic> json) {
    return ShoeStats(
      totalMileage: (json["total_mileage"] is num)
          ? json["total_mileage"].toDouble()
          : 0.0,
      totalClimb: json["total_climb"] ?? 0,
      totalDuration: json["total_duration"] ?? 0,
      totalPlacesCount: json["total_places_count"] ?? 0,
      usageCount: json["usage_count"] ?? 0,
      maxSingleDistance: (json["max_single_distance"] is num)
          ? json["max_single_distance"].toDouble()
          : 0.0,
      maxSingleDuration: json["max_single_duration"] ?? 0,
    );
  }
}
