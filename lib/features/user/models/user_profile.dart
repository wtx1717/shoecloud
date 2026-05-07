/// 定义会话层使用的完整用户资料聚合模型。
import 'package:shoecloud/features/session/models/user_login.dart';

class UserProfile {
  UserProfile({
    required this.baseInfo,
    required this.physicalStats,
    required this.accountSummary,
    required this.resources,
  });

  final BaseInfo baseInfo;
  final PhysicalStats physicalStats;
  final AccountSummary accountSummary;
  final UserResources resources;

  factory UserProfile.empty() {
    return UserProfile(
      baseInfo: BaseInfo.empty(),
      physicalStats: PhysicalStats.empty(),
      accountSummary: AccountSummary.empty(),
      resources: UserResources.empty(),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      baseInfo: BaseInfo.fromJson(json['baseInfo'] ?? const {}),
      physicalStats: PhysicalStats.fromJson(json['physicalStats'] ?? const {}),
      accountSummary: AccountSummary.fromJson(
        json['accountSummary'] ?? const {},
      ),
      resources: UserResources.fromJson(json['resources'] ?? const {}),
    );
  }

  UserLogin toLogin() {
    return UserLogin(
      userId: baseInfo.userId,
      account: baseInfo.account,
      password: baseInfo.password,
      userName: baseInfo.userName,
      token: baseInfo.token,
    );
  }

  UserProfile copyWith({
    BaseInfo? baseInfo,
    PhysicalStats? physicalStats,
    AccountSummary? accountSummary,
    UserResources? resources,
  }) {
    return UserProfile(
      baseInfo: baseInfo ?? this.baseInfo,
      physicalStats: physicalStats ?? this.physicalStats,
      accountSummary: accountSummary ?? this.accountSummary,
      resources: resources ?? this.resources,
    );
  }
}

class BaseInfo {
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

  final String userId;
  final String account;
  final String password;
  final String token;
  final String userName;
  final String avatarUrl;
  final String gender;
  final String birthday;
  final String registerDate;

  factory BaseInfo.empty() {
    return BaseInfo(
      userId: '',
      account: '',
      password: '',
      token: '',
      userName: '',
      avatarUrl: '',
      gender: '',
      birthday: '',
      registerDate: '',
    );
  }

  factory BaseInfo.fromJson(Map<String, dynamic> json) {
    return BaseInfo(
      userId: json['userId']?.toString() ?? '',
      account: json['account']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      birthday: json['birthday']?.toString() ?? '',
      registerDate: json['registerDate']?.toString() ?? '',
    );
  }

  BaseInfo copyWith({
    String? userName,
    String? avatarUrl,
    String? gender,
    String? birthday,
  }) {
    return BaseInfo(
      userId: userId,
      account: account,
      password: password,
      token: token,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      registerDate: registerDate,
    );
  }
}

class PhysicalStats {
  PhysicalStats({
    required this.height,
    required this.weight,
    required this.shoeSize,
    required this.unit,
  });

  final double height;
  final double weight;
  final double shoeSize;
  final Map<String, dynamic> unit;

  factory PhysicalStats.empty() {
    return PhysicalStats(height: 0, weight: 0, shoeSize: 0, unit: const {});
  }

  factory PhysicalStats.fromJson(Map<String, dynamic> json) {
    return PhysicalStats(
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      shoeSize: (json['shoeSize'] ?? 0).toDouble(),
      unit: Map<String, dynamic>.from(json['unit'] ?? const {}),
    );
  }

  PhysicalStats copyWith({
    double? height,
    double? weight,
    double? shoeSize,
  }) {
    return PhysicalStats(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      shoeSize: shoeSize ?? this.shoeSize,
      unit: unit,
    );
  }
}

class AccountSummary {
  AccountSummary({
    required this.activityCount,
    required this.shoesCount,
  });

  final int activityCount;
  final int shoesCount;

  factory AccountSummary.empty() {
    return AccountSummary(activityCount: 0, shoesCount: 0);
  }

  factory AccountSummary.fromJson(Map<String, dynamic> json) {
    return AccountSummary(
      activityCount: json['activityCount'] ?? 0,
      shoesCount: json['shoesCount'] ?? 0,
    );
  }
}

class UserResources {
  UserResources({
    required this.activityInfoUrl,
    required this.shoesList,
  });

  final String activityInfoUrl;
  final List<UserShoeReference> shoesList;

  factory UserResources.empty() {
    return UserResources(activityInfoUrl: '', shoesList: const []);
  }

  factory UserResources.fromJson(Map<String, dynamic> json) {
    final list = json['shoes']?['shoesList'] as List? ?? const [];
    return UserResources(
      activityInfoUrl: json['activityInfoUrl']?.toString() ?? '',
      shoesList: list
          .map((item) => UserShoeReference.fromJson(item))
          .toList(),
    );
  }
}

class UserShoeReference {
  UserShoeReference({
    required this.shoeId,
    required this.shoeName,
    required this.detailUrl,
  });

  final String shoeId;
  final String shoeName;
  final String detailUrl;

  factory UserShoeReference.fromJson(Map<String, dynamic> json) {
    return UserShoeReference(
      shoeId: json['shoeId']?.toString() ?? '',
      shoeName: json['shoeName']?.toString() ?? '',
      detailUrl: json['detailUrl']?.toString() ?? '',
    );
  }
}
