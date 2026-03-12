import 'package:shoecloud/utils/DioRequest.dart';

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
