/// 注册新架构运行所需的全局依赖。
import 'package:get/get.dart';
import 'package:shoecloud/core/nfc/deep_link_nfc_manager.dart';
import 'package:shoecloud/core/network/api_client.dart';
import 'package:shoecloud/core/storage/session_storage.dart';
import 'package:shoecloud/features/auth/data/auth_repository.dart';
import 'package:shoecloud/features/auth/presentation/controllers/auth_controller.dart';
import 'package:shoecloud/features/home/presentation/controllers/home_controller.dart';
import 'package:shoecloud/features/profile/domain/profile_service.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/features/shoes/data/shoe_repository.dart';
import 'package:shoecloud/features/shoes/domain/shoe_service.dart';
import 'package:shoecloud/features/user/data/user_repository.dart';

Future<void> setupDependencies() async {
  final storage = Get.put(SessionStorage(), permanent: true);
  final client = Get.put(ApiClient(storage), permanent: true);
  final userRepository = Get.put(UserRepository(client), permanent: true);
  final shoeRepository = Get.put(ShoeRepository(client), permanent: true);
  final authRepository = Get.put(AuthRepository(client), permanent: true);

  final session = Get.put(
    AppSessionController(storage, userRepository),
    permanent: true,
  );

  Get.put(AuthController(authRepository, session), permanent: true);
  Get.put(HomeController(shoeRepository, session), permanent: true);
  Get.put(ProfileService(userRepository, session), permanent: true);
  Get.put(ShoeService(shoeRepository, session), permanent: true);
  Get.put(DeepLinkNfcManager(shoeRepository), permanent: true);
}
