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
    // 采用圆角卡片化设计
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        // 森林绿渐变背景
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: !widget.isLogin ? _buildLoggedOutUI() : _buildLoggedInUI(),
    );
  }

  //未登录界面
  Widget _buildLoggedOutUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 30),
        //头像
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(width: 30),
        //提示登录
        Center(
          child: clickableWrapper(
            route: "login",
            child: const Text(
              "点击登录",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //已登录界面
  Widget _buildLoggedInUI() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 30),
          //头像
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                _userController.fullInfo.value?.baseInfo.avatarUrl ??
                    "https://example.com/user_avatar.png",
              ),
              // 如果图片加载失败的逻辑保留
            ),
          ),
          const SizedBox(width: 20),
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
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  clickableWrapper(
                    route: "userInfoEditView",
                    child: Image.asset(
                      "lib/assets/my/edit.png",
                      height: 18,
                      width: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const BetaBadge(),
              const SizedBox(height: 8),
              const Text(
                '探索你的云端鞋柜',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          //将内容推向右侧
          const Spacer(),
          clickableWrapper(
            isDeveloping: true,
            route: "进入个人首页",
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 25),
              child: const Row(
                children: [
                  Text(
                    '空间',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
