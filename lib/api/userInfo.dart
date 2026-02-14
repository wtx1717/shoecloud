import 'package:shoecloud/constants/index.dart';
import 'package:shoecloud/utils/DioRequest.dart';
import 'package:shoecloud/viewmodels/userInfo.dart'; // 导入我们定义的 UserInfoModel

/// 获取用户详细信息 API
///
/// [说明]：
/// 本接口用于根据用户 ID 或当前登录状态获取完整的个人画像数据。
/// 包括基础资料 (BaseInfo)、身体数据 (PhysicalStats)、账户统计 (AccountSummary) 以及资源链接 (Resources)。
///
/// [参数]：
/// - [infoUrl] 用户模型中存储的个性化信息地址（如：shoecloud.cn/userInfo/user_example/userInfo_base.json）
///
/// [返回值]：
/// - 请求成功：返回 [UserInfoModel] 业务模型对象
/// - 请求失败或数据异常：返回 `null`
Future<UserInfoModel?> getUserInfoAPI(String infoUrl) async {
  try {
    // 1. 发起网络请求
    // 注意：此处直接请求用户模型中提供的特定 infoUrl 地址。
    // 根据你的 DioRequest 封装逻辑，假设拦截器已处理 code=1 校验，返回的是 data["result"] 部分。
    final response = await dioRequest.get(HttpConstants.USERINFO + infoUrl);

    // 2. 校验返回数据
    // 预期 response 是一个 Map<String, dynamic> 结构，包含 baseInfo, physicalStats 等嵌套字段。
    if (response != null && response is Map<String, dynamic>) {
      // 3. 执行模型序列化
      // 调用我们在 viewmodels 中定义的 formJSON 构造函数，将 Map 转换为强类型的业务实体。
      // 这样 UI 层可以直接通过 user.physicalStats.height 访问数据，具备代码提示且类型安全。
      return UserInfoModel.formJSON(response);
    }
  } catch (e) {
    // 4. 异常处理
    // 捕获网络连接超时、404 或 JSON 解析失败等异常。
    // 在调试模式下可以打印具体错误，生产环境下返回 null 供 UI 层展示“加载失败”或“数据异常”。
    print("获取用户信息失败: $e");
    return null;
  }

  // 若返回数据格式非 Map 或为空，判定为数据获取失效。
  return null;
}

/// 修改用户详细信息 API
///
/// [说明]：
/// 对接 Python 后端服务，支持手术级修改 JSON 文件中的特定字段。
///
/// [参数]：
/// - [userId] 用户唯一 ID (对应服务器文件夹名 user_{userId})
/// - [updateFields] 需要修改的字段 Map。
///   例如：{"userName": "新昵称"} 或 {"height": 185.5, "weight": 70.0}
///
/// [返回值]：
/// - 修改成功：返回 true
/// - 修改失败或异常：返回 false
Future<bool> updateUserInfoAPI(
  String userId,
  Map<String, dynamic> updateFields,
) async {
  try {
    // 1. 组装请求参数
    // 必须包含 userId，其余字段通过解构赋值混入
    final Map<String, dynamic> params = {"userId": userId, ...updateFields};

    // 2. 发起 POST 请求
    // 注意：HttpConstants.UPDATE_USERINFO 需要你在 constants 里定义为 "/update_user_info"
    final response = await dioRequest.post(
      HttpConstants.UPDATE_USERINFO,
      params: params,
    );

    // 3. 根据你的 DioRequest 逻辑：
    // 如果 code == 1，handleResponse 会返回 data["result"]
    // 如果 code != 1，handleResponse 会直接抛出 Exception 进入下面的 catch
    if (response != null) {
      return true;
    }
    return false;
  } catch (e) {
    print("修改用户信息失败 API 异常: $e");
    return false;
  }
}
