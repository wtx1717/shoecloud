/// 定义跑鞋业务流程中使用的详细跑鞋模型。
class Shoe {
  Shoe({
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

  final String shoeId;
  final String shoeName;
  final String brand;
  final String nickname;
  final double size;
  final double purchasePrice;
  final double retailPrice;
  final String releaseDate;
  final String imageUrl;
  final String bindTime;
  final bool isRetired;
  final String category;
  final List<String> features;
  final ShoeStats stats;
  final String activitiesLink;

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      shoeId: json['shoe_id']?.toString() ?? '',
      shoeName: json['shoe_name']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      size: (json['size'] is num) ? json['size'].toDouble() : 0.0,
      purchasePrice: (json['purchase_price'] is num)
          ? json['purchase_price'].toDouble()
          : 0.0,
      retailPrice: (json['retail_price'] is num)
          ? json['retail_price'].toDouble()
          : 0.0,
      releaseDate: json['release_date']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      bindTime: json['bind_time']?.toString() ?? '',
      isRetired: json['is_retired'] == true,
      category: json['category']?.toString() ?? '',
      features: List<String>.from(json['features'] ?? const []),
      stats: ShoeStats.fromJson(json['stats'] ?? const {}),
      activitiesLink: json['activities_link']?.toString() ?? '',
    );
  }

  Shoe copyWith({
    String? nickname,
    double? size,
    double? purchasePrice,
    bool? isRetired,
  }) {
    return Shoe(
      shoeId: shoeId,
      shoeName: shoeName,
      brand: brand,
      nickname: nickname ?? this.nickname,
      size: size ?? this.size,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      retailPrice: retailPrice,
      releaseDate: releaseDate,
      imageUrl: imageUrl,
      bindTime: bindTime,
      isRetired: isRetired ?? this.isRetired,
      category: category,
      features: features,
      stats: stats,
      activitiesLink: activitiesLink,
    );
  }
}

class ShoeStats {
  ShoeStats({
    required this.totalMileage,
    required this.totalClimb,
    required this.totalDuration,
    required this.totalPlacesCount,
    required this.usageCount,
    required this.maxSingleDistance,
    required this.maxSingleDuration,
  });

  final double totalMileage;
  final int totalClimb;
  final int totalDuration;
  final int totalPlacesCount;
  final int usageCount;
  final double maxSingleDistance;
  final int maxSingleDuration;

  factory ShoeStats.fromJson(Map<String, dynamic> json) {
    return ShoeStats(
      totalMileage: (json['total_mileage'] is num)
          ? json['total_mileage'].toDouble()
          : 0.0,
      totalClimb: json['total_climb'] ?? 0,
      totalDuration: json['total_duration'] ?? 0,
      totalPlacesCount: json['total_places_count'] ?? 0,
      usageCount: json['usage_count'] ?? 0,
      maxSingleDistance: (json['max_single_distance'] is num)
          ? json['max_single_distance'].toDouble()
          : 0.0,
      maxSingleDuration: json['max_single_duration'] ?? 0,
    );
  }
}
