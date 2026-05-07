/// 管理全局登录会话与用户资料快照。
import 'package:get/get.dart';
import 'package:shoecloud/core/storage/session_storage.dart';
import 'package:shoecloud/features/session/models/user_login.dart';
import 'package:shoecloud/features/user/data/user_repository.dart';
import 'package:shoecloud/features/user/models/user_profile.dart';

class AppSessionController extends GetxController {
  AppSessionController(this._storage, this._userRepository);

  final SessionStorage _storage;
  final UserRepository _userRepository;

  final login = UserLogin.empty().obs;
  final profile = Rxn<UserProfile>();
  final isBootstrapping = true.obs;

  bool get isLoggedIn => login.value.isLoggedIn;
  String get userId => login.value.userId;
  String get token => _storage.token;

  Future<void> bootstrap() async {
    isBootstrapping.value = true;
    await _storage.init();

    if (_storage.hasSession) {
      final stub = UserLogin(
        userId: _storage.userId,
        account: '',
        password: '',
        userName: '',
        token: _storage.token,
      );
      login.value = stub;
      await refreshUserProfile();
    }

    isBootstrapping.value = false;
  }

  Future<void> setSession(UserLogin user) async {
    await _storage.saveSession(token: user.token, userId: user.userId);
    login.value = user;
    await refreshUserProfile();
  }

  Future<void> clearSession() async {
    await _storage.clear();
    login.value = UserLogin.empty();
    profile.value = null;
  }

  Future<void> refreshUserProfile() async {
    if (login.value.userId.isEmpty) {
      return;
    }

    final fetched = await _userRepository.fetchUserProfile(
      '/user_${login.value.userId}/userInfo_base.json?t=${DateTime.now().millisecondsSinceEpoch}',
    );

    if (fetched != null) {
      profile.value = fetched;
      login.value = fetched.toLogin();
    }
  }

  void updateProfile(UserProfile nextProfile) {
    profile.value = nextProfile;
  }
}
