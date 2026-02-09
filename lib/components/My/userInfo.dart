import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/components/My/Badge/example.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';
import 'package:shoecloud/stores/userController.dart';

// ignore: must_be_immutable, camel_case_types
class userInfo extends StatefulWidget {
  //是否登录
  bool isLogin;
  userInfo({super.key, required this.isLogin});

  @override
  State<userInfo> createState() => _userInfoState();
}

class _userInfoState extends State<userInfo> {
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return !widget.isLogin ? _buildLoggedOutUI() : _buildLoggedInUI();
  }

  //未登录界面
  Widget _buildLoggedOutUI() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 40),
          //头像
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Image.network(
              "example.com/user_avatar.png",
              //链接错误则返回默认头像
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, size: 50, color: Colors.grey);
              },
            ),
          ),
          SizedBox(width: 40),
          //提示登录
          Center(
            child: clickableWrapper(
              route: "login",
              child: Text(
                "点击登录",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //已登录界面
  Widget _buildLoggedInUI() {
    return Obx(() {
      return Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 40),
            //头像
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Image.network(
                _userController.fullInfo.value?.baseInfo.avatarUrl ??
                    "example.com/user_avatar.png",
                //链接错误则返回默认头像
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, size: 50, color: Colors.grey);
                },
              ),
            ),
            SizedBox(width: 40),
            //信息栏
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _userController.fullInfo.value?.baseInfo.userName ??
                          '初始用户名',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    clickableWrapper(
                      route: "编辑个人资料",
                      child: Image.asset(
                        "lib/assets/my/edit.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                BetaBadge(),
                SizedBox(height: 6),
                Text(
                  '其他信息',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),

            //将内容推向右侧
            Spacer(),
            clickableWrapper(
              route: "进入个人首页",
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 40),
                child: Row(
                  children: [
                    Text(
                      '空间',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
