//存放全局常量
class GlobalConstants {
  // ignore: constant_identifier_names
  static const BASE_URL = "https://www.shoecloud.cn"; //基础地址
  // ignore: constant_identifier_names
  static const int TIME_OUT = 10; //超时时间
  // ignore: constant_identifier_names
  static const String SUCCESS_CODE = "1";
  // ignore: constant_identifier_names
  static const String TOKEN_KEY = "shoecloud_token"; //token对应持久化的key
}

//存放请求地址接口的常量
class HttpConstants {
  // ignore: constant_identifier_names
  static const String BANNER_LIST =
      "/uploadtest/config/addShoeInfoExample.json";
  // ignore: constant_identifier_names
  static const String LOGIN = "/login/user_info.json";
  // ignore: constant_identifier_names
  static const String USERINFO = "/userInfo";
  // ignore: constant_identifier_names
  static const String UPDATE_USERINFO = "/update_user_info";
  // ignore: constant_identifier_names
  static const String ADD_NEWSHOE = "/add_new_shoe";
}
