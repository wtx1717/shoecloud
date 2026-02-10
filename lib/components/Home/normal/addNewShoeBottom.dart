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
      child: Container(
        width: 42, // 稍微缩小一点，让它在分类栏末尾更精致
        height: 42,
        decoration: BoxDecoration(
          // 使用奶油黄作为主色调，呼应品牌色
          color: const Color(0xFFFFF9C4),
          borderRadius: BorderRadius.circular(14), // 大圆角矩形，比正圆更有现代感
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.1), // 淡淡的森林绿投影
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // 使用 Stack 手动绘制一个纤细的加号，比系统图标更有设计感
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 横线
              Container(
                width: 18,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 竖线
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
