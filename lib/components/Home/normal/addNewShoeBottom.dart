// 添加新跑鞋组件
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';
import 'package:shoecloud/stores/userController.dart';

class addNewShoeBottom extends StatefulWidget {
  const addNewShoeBottom({super.key});

  @override
  State<addNewShoeBottom> createState() => _addNewShoeBottomState();
}

class _addNewShoeBottomState extends State<addNewShoeBottom> {
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return clickableWrapper(
      //如果用户没有登录，硬解码到登录页面
      //如果用户已经登录，硬解码到添加新跑鞋页面
      route: _userController.fullInfo.value == null ? "login" : "addNewShoe",
      child: Image.asset(
        width: 50,
        height: 50,
        "lib/assets/home/addNewShoe.png",
      ),
    );
  }
}
