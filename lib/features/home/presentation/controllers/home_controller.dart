/// 为首页 Tab 加载当前用户的跑鞋列表。
import 'package:get/get.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/features/shoes/data/shoe_repository.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';

class HomeController extends GetxController {
  HomeController(this._repository, this._sessionController);

  final ShoeRepository _repository;
  final AppSessionController _sessionController;

  final shoes = <Shoe>[].obs;
  final isLoading = false.obs;

  Future<void> load() async {
    if (!_sessionController.isLoggedIn ||
        _sessionController.profile.value == null) {
      shoes.clear();
      return;
    }

    isLoading.value = true;
    try {
      final result = await _repository.fetchShoes(
        _sessionController.profile.value!.resources.shoesList,
      );
      shoes.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAll() async {
    await _sessionController.refreshUserProfile();
    await load();
  }
}
