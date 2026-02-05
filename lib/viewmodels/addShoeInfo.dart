class addShoeInfo {
  int id;
  String name;
  String? brand;
  double? release_price;
  int? release_year;
  List<String>? features;
  List<String> imagesUrl;
  String? description;
  String? category;
  addShoeInfo({
    required this.id,
    required this.name,
    this.brand,
    this.release_price,
    this.release_year,
    this.features,
    this.category,
    this.description,
    required this.imagesUrl,
  });

  //扩展一个工厂函数，一般用factory来声明，一般用来创建实例对象
  factory addShoeInfo.formJSON(Map<String, dynamic> json) {
    //必须返回一个addShoeInfo对象
    return addShoeInfo(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      release_price: json["release_price"] ?? 0.0,
      release_year: json["release_year"] ?? 1717,
      //注意，这里的json["features"]是一个List<dynamic>格式，不能直接转成List<String>类型，因为dart不支持隐式转换！
      //这个bug卡了我俩小时hhh
      features: (json["features"] as List?)?.cast<String>() ?? ["功能暂不明确"],
      category: json["category"] ?? "分类暂不明确",
      description: json["description"] ?? "暂无描述",
      imagesUrl: (json["imagesUrl"] as List?)?.cast<String>() ?? [],
    );
  }
}
