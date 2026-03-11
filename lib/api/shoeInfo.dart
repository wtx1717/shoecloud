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
  if (shoesList.isEmpty) return [];

  try {
    // 【核心修改】：给每一个详情请求 URL 都加上时间戳，破除 Nginx/服务器缓存
    final String timestamp = "?t=${DateTime.now().millisecondsSinceEpoch}";

    final List<Future<dynamic>> requests = shoesList.map((item) {
      // 拼接 URL 时强行加入随机后缀
      return dioRequest.get(HttpConstants.USERINFO + item.detailUrl + timestamp);
    }).toList();

    final List<dynamic> responses = await Future.wait(requests);

    List<ShoeInfo> resultList = [];
    for (var response in responses) {
      if (response != null && response is Map<String, dynamic>) {
        try {
          resultList.add(ShoeInfo.formJSON(response));
        } catch (e) {
          print("单条跑鞋数据解析失败: $e");
        }
      }
    }
    return resultList;
  } catch (e) {
    print("批量获取跑鞋详情时发生网络错误: $e");
    return [];
  }
}

Future<ShoeInfo?> getSingleShoeByIdAPI(String shoeId) async {
  try {
    final String timestamp = "?t=${DateTime.now().millisecondsSinceEpoch}";
    final String url =
        "${HttpConstants.USERINFO}/user_example/shoes/shoe_$shoeId/shoe_$shoeId.json$timestamp";
    
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
  required Map<String, dynamic> fullDetail,
}) async {
  try {
    final Map<String, dynamic> updatePayload = {
      "userId": userId,
      "newEntry": {
        "shoeId": newShoeId,
        "shoeName": newShoeName,
        "detailUrl": ShoeUpdateUtils.getDetailUrl(userId, newShoeId),
      },
      "fullDetail": fullDetail,
    };

    // POST 请求通常不会被缓存，但要确保后端处理完后立即释放文件锁
    await dioRequest.post(
      HttpConstants.ADD_NEWSHOE,
      params: updatePayload,
    );
    return true;
  } catch (e) {
    print("修改 userInfo_base.json 索引失败: $e");
    return false;
  }
}

/// 修改跑鞋详情信息
Future<bool> updateShoeDetailAPI({
  required String userId,
  required String shoeId,
  required Map<String, dynamic> newInfo,
}) async {
  try {
    // 如果 _handleResponse 校验失败，它会直接 throw Exception 进入 catch
    await dioRequest.post(
      "/update_shoe_detail",
      params: {
        "user_id": userId,
        "shoe_id": shoeId,
        "new_info": newInfo,
      },
    );
    return true; // 走到这里说明 code 一定是 SUCCESS_CODE
  } catch (e) {
    print("更新跑鞋详情失败: $e");
    return false;
  }
}

/// 删除跑鞋
Future<bool> deleteShoeAPI({
  required String userId,
  required String shoeId,
}) async {
  try {
    await dioRequest.post(
      "/delete_shoe",
      params: { "user_id": userId, "shoe_id": shoeId },
    );
    return true; 
  } catch (e) {
    print("删除跑鞋失败: $e");
    return false;
  }
}