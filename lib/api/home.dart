// 封装一个api：目的是返回业务侧要的数据结构
// 这个文件负责把网络请求得到的原始数据，转换成 viewmodels 中的业务模型，然后返回给 UI 层使用
import 'package:shoecloud/constants/index.dart';
import 'package:shoecloud/utils/DioRequest.dart';
import 'package:shoecloud/viewmodels/home.dart';

/// 获取“新增鞋子信息”列表的 API
///
/// 返回值：Future<List<addShoeInfo>>
/// 功能说明：
/// 1. 使用 `dioRequest.get` 向 `HttpConstants.BANNER_LIST` 发起 GET 请求。
/// 2. 假设后端返回一个 List（每个元素为 Map<String, dynamic>）。
/// 3. 将每一项 Map 转换为 `addShoeInfo` 对象（通过 `formJSON` 构造器）。
/// 4. 将转换后的 Iterable 转为 List 并返回给业务层。
///
/// 注意：如果后端返回的数据结构与预期不匹配（比如不是 List，或元素不是 Map），
///       这里会抛出类型转换错误，请在调用处或网络层做好错误处理。
Future<List<addShoeInfo>> getAddShoeInfoListAPI() async {
  // 发送网络请求并接收响应（动态类型），推荐在网络层统一做异常/错误处理
  final response = await dioRequest.get(HttpConstants.BANNER_LIST);

  // 将响应断言为 List，然后逐项转换为 addShoeInfo
  // map 返回的是 Iterable，需要调用 toList() 转为 List
  return (response as List).map((item) {
    // 把每个 Map<String, dynamic> 转换为 addShoeInfo 实例
    return addShoeInfo.formJSON(item as Map<String, dynamic>);
  }).toList();
}
