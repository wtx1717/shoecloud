/// 存放应用级常量与接口路径定义。
class AppConstants {
  static const String baseUrl = 'https://www.shoecloud.cn';
  static const int timeoutSeconds = 10;
  static const String successCode = '1';
  static const String tokenStorageKey = 'token_key';
  static const String userIdStorageKey = 'user_id_key';
}

class ApiPaths {
  static const String login = '/login/user_info.json';
  static const String userInfo = '/userInfo';
  static const String updateUserInfo = '/update_user_info';
  static const String addNewShoe = '/add_new_shoe';
  static const String addShoeCatalog =
      '/uploadtest/config/addShoeInfoExample.json';
  static const String updateShoeDetail = '/update_shoe_detail';
  static const String deleteShoe = '/delete_shoe';
  static const String checkPendingActivities = '/check_pending_activities';
  static const String moveSingleActivity = '/move_single_activity';
  static const String deleteSyncedActivity = '/delete_synced_activity';
}
