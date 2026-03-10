import 'dart:math';

import 'package:shoecloud/constants/index.dart';
import 'package:shoecloud/utils/DioRequest.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';
import 'package:shoecloud/viewmodels/userInfo.dart';

/// 批量获取跑鞋详细信息接口
///
/// [说明]：
/// 本接口接收从 UserInfoModel 中解析出的 ShoeItem 列表。
/// 采用并发请求机制 (Future.wait)，通过每双鞋自带的 detailUrl 获取完整的跑鞋参数。
///
/// [参数]：
/// - [shoesList] 对应 UserInfoModel.resources.shoesList，包含 detailUrl 的索引列表。
///
/// [返回值]：
/// - 请求成功：返回 [List<ShoeInfo>] 跑鞋详细模型数组
/// - 若部分请求失败：会过滤掉失败的项，仅返回加载成功的数据
Future<List<ShoeInfo>> getShoeInfoAPI(List<ShoeItem> shoesList) async {
  // 1. 如果列表为空，直接返回空数组
  if (shoesList.isEmpty) return [];

  try {
    // 2. 将索引列表映射为一组 Future 请求任务
    // 使用 GET 方法请求每一个 detailUrl
    final List<Future<dynamic>> requests = shoesList.map((item) {
      return dioRequest.get(HttpConstants.USERINFO + item.detailUrl);
    }).toList();

    // 3. 并发执行所有请求
    // Future.wait 会等待所有网络请求返回结果
    final List<dynamic> responses = await Future.wait(requests);

    // 4. 解析结果并过滤异常
    List<ShoeInfo> resultList = [];
    for (var response in responses) {
      if (response != null && response is Map<String, dynamic>) {
        try {
          // 将每一个成功的响应转化为 ShoeInfo 模型
          resultList.add(ShoeInfo.formJSON(response));
        } catch (e) {
          print("单条跑鞋数据解析失败: $e");
        }
      }
    }

    return resultList;
  } catch (e) {
    // 5. 全局异常处理
    print("批量获取跑鞋详情时发生网络错误: $e");
    return [];
  }
}

Future<ShoeInfo?> getSingleShoeByIdAPI(String shoeId) async {
  try {
    // 直接拼接路径请求
    final String url =
        "${HttpConstants.USERINFO}/user_example/shoes/shoe_$shoeId/shoe_$shoeId.json";
    final response = await dioRequest.get(url);

    if (response != null && response is Map<String, dynamic>) {
      return ShoeInfo.formJSON(response);
    }
  } catch (e) {
    print("NFC单条查询失败: $e");
  }
  return null;
}

class ShoeUpdateUtils {
  /// 生成唯一的鞋子 ID (时间戳 + 3位随机数)
  static String generateShoeId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = Random().nextInt(900) + 100; // 100-999
    return "$timestamp$random";
  }

  /// 构建存储路径
  /// 格式如：/user_1/shoes/shoe_123456/shoe_123456.json
  static String getDetailUrl(String userId, String shoeId) {
    return "/user_$userId/shoes/shoe_$shoeId/shoe_$shoeId.json";
  }
}

/// 更新用户信息基础索引文件 (userInfo_base.json)
///
/// [参数]:
/// - [userId]: 当前用户ID
/// - [newShoeName]: 跑鞋型号名称
/// - [newShoeId]: 预先生成的唯一ID
Future<bool> updateUserBaseIndexAPI({
  required String userId,
  required String newShoeName,
  required String newShoeId,
  required Map<String, dynamic> fullDetail, // 新增：传入详细信息
}) async {
  try {
    final Map<String, dynamic> updatePayload = {
      "userId": userId,
      "newEntry": {
        "shoeId": newShoeId,
        "shoeName": newShoeName,
        "detailUrl": ShoeUpdateUtils.getDetailUrl(userId, newShoeId),
      },
      "fullDetail": fullDetail, // 补全后端需要的字段
    };

    final response = await dioRequest.post(
      HttpConstants.ADD_NEWSHOE,
      params: updatePayload,
    );
    return true;
  } catch (e) {
    print("修改 userInfo_base.json 索引失败: $e");
    return false;
  }
}
