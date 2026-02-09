import 'package:shoecloud/viewmodels/userLogin.dart';

class UserInfoModel {
  // 用户基本信息
  BaseInfo baseInfo;
  // 用户身体统计数据
  PhysicalStats physicalStats;
  // 用户账户摘要信息
  AccountSummary accountSummary;
  // 用户资源信息
  Resources resources;

  UserInfoModel({
    required this.baseInfo,
    required this.physicalStats,
    required this.accountSummary,
    required this.resources,
  });

  /// 将复杂的详细信息模型转换为精简的登录模型
  ///
  /// 功能：从 baseInfo 中提取 UI 校验和基础展示所需的字段
  userLogin toUserLogin() {
    return userLogin(
      userId: baseInfo.userId,
      account: baseInfo.account,
      password: baseInfo.password,
      userName: baseInfo.userName,
      token: baseInfo.token,
    );
  }

  // 从 JSON 数据创建 UserInfoModel 实例
  factory UserInfoModel.formJSON(Map<String, dynamic> json) {
    return UserInfoModel(
      baseInfo: BaseInfo.formJSON(json["baseInfo"] ?? {}),
      physicalStats: PhysicalStats.formJSON(json["physicalStats"] ?? {}),
      accountSummary: AccountSummary.formJSON(json["accountSummary"] ?? {}),
      resources: Resources.formJSON(json["resources"] ?? {}),
    );
  }
}

class BaseInfo {
  String userId;
  String account;
  String password;
  String token;
  String userName;
  String avatarUrl;
  String gender;
  String birthday;
  String registerDate;

  BaseInfo({
    required this.userId,
    required this.account,
    required this.password,
    required this.token,
    required this.userName,
    required this.avatarUrl,
    required this.gender,
    required this.birthday,
    required this.registerDate,
  });

  // 从 JSON 数据创建 BaseInfo 实例
  factory BaseInfo.formJSON(Map<String, dynamic> json) {
    return BaseInfo(
      userId: json["userId"]?.toString() ?? "",
      account: json["account"] ?? "",
      password: json["password"] ?? "",
      token: json["token"] ?? "",
      userName: json["userName"] ?? "",
      avatarUrl: json["avatarUrl"] ?? "",
      gender: json["gender"] ?? "",
      birthday: json["birthday"] ?? "",
      registerDate: json["registerDate"] ?? "",
    );
  }
}

class PhysicalStats {
  double height;
  double weight;
  double shoeSize;
  Map<String, dynamic> unit;

  PhysicalStats({
    required this.height,
    required this.weight,
    required this.shoeSize,
    required this.unit,
  });

  // 从 JSON 数据创建 PhysicalStats 实例
  factory PhysicalStats.formJSON(Map<String, dynamic> json) {
    return PhysicalStats(
      height: (json["height"] ?? 0).toDouble(),
      weight: (json["weight"] ?? 0).toDouble(),
      shoeSize: (json["shoeSize"] ?? 0).toDouble(),
      unit: json["unit"] ?? {},
    );
  }
}

class AccountSummary {
  int activityCount;
  int shoesCount;

  AccountSummary({required this.activityCount, required this.shoesCount});

  // 从 JSON 数据创建 AccountSummary 实例
  factory AccountSummary.formJSON(Map<String, dynamic> json) {
    return AccountSummary(
      activityCount: json["activityCount"] ?? 0,
      shoesCount: json["shoesCount"] ?? 0,
    );
  }
}

class Resources {
  String activityInfoUrl;
  List<ShoeItem> shoesList;

  Resources({required this.activityInfoUrl, required this.shoesList});

  // 从 JSON 数据创建 Resources 实例
  factory Resources.formJSON(Map<String, dynamic> json) {
    var list = json["shoes"]?["shoesList"] as List? ?? [];
    return Resources(
      activityInfoUrl: json["activityInfoUrl"] ?? "",
      shoesList: list.map((i) => ShoeItem.formJSON(i)).toList(),
    );
  }
}

class ShoeItem {
  String shoeId;
  String shoeName;
  String detailUrl;

  ShoeItem({
    required this.shoeId,
    required this.shoeName,
    required this.detailUrl,
  });

  // 从 JSON 数据创建 ShoeItem 实例
  factory ShoeItem.formJSON(Map<String, dynamic> json) {
    return ShoeItem(
      shoeId: json["shoeId"]?.toString() ?? "",
      shoeName: json["shoeName"] ?? "",
      detailUrl: json["detailUrl"] ?? "",
    );
  }

  Object? operator [](String other) {}
}
