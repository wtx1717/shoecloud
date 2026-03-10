import 'package:get/get.dart';
import 'package:shoecloud/constants/index.dart';
import 'package:shoecloud/utils/DioRequest.dart';
import 'package:shoecloud/viewmodels/userInfo.dart';
import 'package:shoecloud/viewmodels/userLogin.dart';

//需要共享的对象，要有一些共享的属性，属性需要响应式更新
class UserController extends GetxController {
  var loginInfo = userLogin.formJSON({}).obs; //user对象被监听了
  var fullInfo = Rxn<UserInfoModel>();

  //想要取值的话，需要user.value
  void updateuserLogin(userLogin newUser) {
    loginInfo.value = newUser;
  }

  void updateFullInfo(UserInfoModel newFullInfo) {
    fullInfo.value = newFullInfo;
    fullInfo.refresh(); //刷新，触发更新
  }

  /// 【新增】主动从服务器同步最新的用户信息
  Future<void> refreshUserInfo() async {
    if (loginInfo.value.userId.isEmpty) return;

    try {
      // 构建请求路径，例如：/userInfo/user_1/userInfo_base.json
      final String url =
          "${HttpConstants.USERINFO}/user_${loginInfo.value.userId}/userInfo_base.json";

      // 注意：这里使用 dioRequest.get，它已经处理了 code == "1" 并返回 result 部分
      final response = await dioRequest.get(url);

      if (response != null) {
        // 将最新的 JSON 重新解析为模型
        final updatedInfo = UserInfoModel.formJSON(response);
        // 更新响应式变量，首页的 Obx 就会立刻检测到 shoesCount 变了！
        fullInfo.value = updatedInfo;
      }
    } catch (e) {
      print("UserController 同步用户信息失败: $e");
    }
  }
}
