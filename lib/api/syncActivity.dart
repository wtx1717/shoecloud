import 'package:shoecloud/utils/DioRequest.dart';
import 'package:shoecloud/viewmodels/shoeActivity.dart';

/// 检查用户待处理活动文件的 API
///
/// 请求参数：userId
/// 返回值：Map 包含 count(文件数) 和 files(文件名列表)
Future<Map<String, dynamic>?> checkPendingActivitiesAPI({
  required String userId,
}) async {
  try {
    // 使用你封装好的 dioRequest.post
    // 注意：params 传入 Map，DioRequest 内部会自动处理成 JSON body
    final response = await dioRequest.post(
      "/check_pending_activities",
      params: {"userId": userId},
    );

    // response 已经是 dioRequest 帮你剥离出来的 "result" 内容了
    if (response != null) {
      return response as Map<String, dynamic>;
    }
    return null;
  } catch (e) {
    // 这里捕获的是 dioRequest 抛出的 Exception
    print("API层获取待处理文件失败: $e");
    return null;
  }
}

/// 移动并同步单个活动文件
Future<Map<String, dynamic>?> moveSingleActivityAPI({
  required String userId,
  required String shoeId,
  String? fileName,
}) async {
  try {
    final response = await dioRequest.post(
      "/move_single_activity",
      params: {
        "userId": userId,
        "shoeId": shoeId, // 必须传给后端
        "fileName": fileName,
      },
    );
    return response as Map<String, dynamic>?;
  } catch (e) {
    print("同步合并失败: $e");
    return null;
  }
}

/// 获取指定跑鞋的所有运动记录列表
/// [url]: 对应 ShoeInfo 模型中的 activitiesLink
Future<List<ShoeActivity>> getShoeActivitiesAPI(String url) async {
  if (url.isEmpty) return [];

  try {
    // 同样加上时间戳破除缓存
    final String timestamp = url.contains('?')
        ? "&t=${DateTime.now().millisecondsSinceEpoch}"
        : "?t=${DateTime.now().millisecondsSinceEpoch}";

    // 注意：由于 dioRequest.get 内部已经处理了 _handleResponse 并返回了 data["result"]
    // 所以这里的 response 直接就是 List<dynamic>
    final dynamic response = await dioRequest.get(url + timestamp);

    if (response != null && response is List) {
      return response.map((item) => ShoeActivity.formJSON(item)).toList();
    }
  } catch (e) {
    print("获取运动记录列表失败: $e");
  }
  return [];
}

/// 获取单条运动记录的详细轨迹与统计信息
/// [jsonUrl]: 对应 ShoeActivity 中的 jsonUrl
Future<Map<String, dynamic>?> getActivityDetailAPI(String jsonUrl) async {
  if (jsonUrl.isEmpty) return null;

  try {
    final String timestamp = jsonUrl.contains('?')
        ? "&t=${DateTime.now().millisecondsSinceEpoch}"
        : "?t=${DateTime.now().millisecondsSinceEpoch}";

    // 返回的是 activities.json 中的 result 对象，包含 summary 和 track
    final dynamic response = await dioRequest.get(jsonUrl + timestamp);

    if (response != null && response is Map<String, dynamic>) {
      return response;
    }
  } catch (e) {
    print("获取活动详情轨迹失败: $e");
  }
  return null;
}

/// 删除/撤销已同步的活动
/// 逻辑：从跑鞋里程中扣除，从 activities.json 移除，并将 JSON 文件移回待处理文件夹
Future<bool> deleteSyncedActivityAPI({
  required String userId,
  required String shoeId,
  required String activityId,
}) async {
  try {
    final response = await dioRequest.post(
      "/delete_synced_activity",
      params: {"userId": userId, "shoeId": shoeId, "activityId": activityId},
    );
    return response != null;
  } catch (e) {
    // 这里会打印出具体的 404 Detail 内容
    print("撤销活动同步失败: $e");
    rethrow; // 抛出异常让 UI 层可以捕获
  }
}
