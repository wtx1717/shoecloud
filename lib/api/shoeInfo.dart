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
        HttpConstants.USERINFO +
        "/user_example/shoes/shoe_$shoeId/shoe_$shoeId.json";
    final response = await dioRequest.get(url);

    if (response != null && response is Map<String, dynamic>) {
      return ShoeInfo.formJSON(response);
    }
  } catch (e) {
    print("NFC单条查询失败: $e");
  }
  return null;
}
