import 'package:shoecloud/constants/index.dart';
import 'package:shoecloud/utils/DioRequest.dart';
import 'package:shoecloud/viewmodels/userLogin.dart';

/// 登录校验业务接口
///
/// [说明]：
/// 由于目前后端暂未上线，我们通过请求静态 JSON 文件的形式模拟登录。
/// 逻辑上，我们需要从服务器拉取全量的用户列表，然后在客户端本地进行信息比对。
///
/// [参数]：
/// - [account] 用户输入的账号
/// - [password] 用户输入的密码
///
/// [返回值]：
/// - 匹配成功：返回 [userLogin] 模型对象
/// - 匹配失败或异常：返回 `null`
Future<userLogin?> getLoginAPI(String account, String password) async {
  // 1. 发起网络请求
  // 虽然是请求静态文件，但保留 POST 传参格式，方便后续无缝对接真实后端 API。
  // dioRequest 内部拦截器已处理业务状态码校验，此处 response 为 data["result"]。
  final response = await dioRequest.post(
    HttpConstants.LOGIN,
    params: {"account": account, "password": password},
  );

  // 2. 校验返回数据类型
  // 预期 response 是一个包含多个用户 Map 的 List（数组）。
  if (response != null && response is List) {
    try {
      // 3. 执行本地检索 (模拟后端数据库查询)
      // firstWhere 会遍历数组，寻找第一条满足条件（账号、密码均一致）的数据。
      // 使用 .toString() 是为了兼容 JSON 中数字类型与字符串类型的比对。
      final matchedItem = response.firstWhere(
        (item) =>
            item["account"].toString() == account &&
            item["password"].toString() == password,
      );

      // 4. 匹配成功：执行模型序列化
      // 将原始 Map 转换为业务实体类，以便 UI 层能够通过点语法（.token）访问数据。
      return userLogin.formJSON(matchedItem as Map<String, dynamic>);
    } catch (e) {
      // 5. 匹配失败处理
      // 当 firstWhere 找不到对应项时会抛出异常，此时判定为“账号或密码错误”。
      // 返回 null 让 UI 层展示错误提示。
      return null;
    }
  }

  // 若返回数据格式非数组或为空，则判定登录流程失效。
  return null;
}
