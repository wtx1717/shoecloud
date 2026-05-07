/// 定义新增跑鞋流程中使用的预置鞋库条目模型。
class ShoeCatalogItem {
  ShoeCatalogItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.releasePrice,
    required this.releaseYear,
    required this.features,
    required this.imagesUrl,
    required this.description,
    required this.category,
  });

  final int id;
  final String name;
  final String brand;
  final double releasePrice;
  final int releaseYear;
  final List<String> features;
  final List<String> imagesUrl;
  final String description;
  final String category;

  factory ShoeCatalogItem.fromJson(Map<String, dynamic> json) {
    return ShoeCatalogItem(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      releasePrice: (json['release_price'] ?? 0).toDouble(),
      releaseYear: json['release_year'] ?? 0,
      features: (json['features'] as List?)?.cast<String>() ?? const [],
      imagesUrl: (json['imagesUrl'] as List?)?.cast<String>() ?? const [],
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }
}
