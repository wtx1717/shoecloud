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
    // 【关键修改】在 URL 后面拼接时间戳 t=${DateTime.now().millisecondsSinceEpoch}
    final String url = 
        "${HttpConstants.USERINFO}/user_${loginInfo.value.userId}/userInfo_base.json?t=${DateTime.now().millisecondsSinceEpoch}";

    print("DEBUG: 正在请求最新数据，URL: $url"); // 你会发现每次请求的后缀都不同

    final response = await dioRequest.get(url);

    if (response != null) {
      final updatedInfo = UserInfoModel.formJSON(response);
      fullInfo.value = updatedInfo;
      fullInfo.refresh(); 
      print("DEBUG: 内存数据已更新，当前鞋子数: ${updatedInfo.accountSummary.shoesCount}");
    }
  } catch (e) {
    print("UserController 同步失败: $e");
  }
}
}
