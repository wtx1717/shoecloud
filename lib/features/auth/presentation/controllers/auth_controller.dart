/// 协调登录提交与会话状态注入。
import 'package:get/get.dart';
import 'package:shoecloud/features/auth/data/auth_repository.dart';
import 'package:shoecloud/features/home/presentation/controllers/home_controller.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';

class AuthController extends GetxController {
  AuthController(this._repository, this._sessionController);

  final AuthRepository _repository;
  final AppSessionController _sessionController;

  final isSubmitting = false.obs;

  Future<bool> login({
    required String account,
    required String password,
  }) async {
    isSubmitting.value = true;
    try {
      final user = await _repository.login(
        account: account,
        password: password,
      );
      if (user == null) {
        return false;
      }

      await _sessionController.setSession(user);
      await Get.find<HomeController>().load();
      return true;
    } finally {
      isSubmitting.value = false;
    }
  }
}
