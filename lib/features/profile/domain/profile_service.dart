/// 处理资料字段更新，并同步会话中的用户信息。
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/features/user/data/user_repository.dart';
import 'package:shoecloud/features/user/models/user_profile.dart';

class ProfileService {
  ProfileService(this._userRepository, this._sessionController);

  final UserRepository _userRepository;
  final AppSessionController _sessionController;

  Future<bool> updateField({
    required String field,
    required dynamic value,
  }) async {
    final userId = _sessionController.userId;
    if (userId.isEmpty || _sessionController.profile.value == null) {
      return false;
    }

    final success = await _userRepository.updateUserInfo(
      userId: userId,
      updateFields: {field: value},
    );

    if (!success) {
      return false;
    }

    final current = _sessionController.profile.value!;
    _sessionController.updateProfile(_nextProfile(current, field, value));
    return true;
  }

  Future<void> logout() {
    return _sessionController.clearSession();
  }

  UserProfile _nextProfile(UserProfile profile, String field, dynamic value) {
    switch (field) {
      case 'userName':
        return profile.copyWith(
          baseInfo: profile.baseInfo.copyWith(userName: value.toString()),
        );
      case 'gender':
        return profile.copyWith(
          baseInfo: profile.baseInfo.copyWith(gender: value.toString()),
        );
      case 'birthday':
        return profile.copyWith(
          baseInfo: profile.baseInfo.copyWith(birthday: value.toString()),
        );
      case 'height':
        return profile.copyWith(
          physicalStats: profile.physicalStats.copyWith(
            height: (value as num).toDouble(),
          ),
        );
      case 'weight':
        return profile.copyWith(
          physicalStats: profile.physicalStats.copyWith(
            weight: (value as num).toDouble(),
          ),
        );
      case 'shoeSize':
        return profile.copyWith(
          physicalStats: profile.physicalStats.copyWith(
            shoeSize: (value as num).toDouble(),
          ),
        );
      default:
        return profile;
    }
  }
}
