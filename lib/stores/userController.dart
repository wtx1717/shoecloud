import 'package:get/get.dart';
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
  }
}
