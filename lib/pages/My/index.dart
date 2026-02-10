import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/components/My/featuresLine.dart';
import 'package:shoecloud/components/My/featuresSquare.dart';
import 'package:shoecloud/components/My/userInfo.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';
import 'package:shoecloud/stores/userController.dart';

class MyView extends StatefulWidget {
  const MyView({super.key});

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  //放入一个对象实例
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    // 背景设为云鞋库浅绿
    return Container(
      color: const Color(0xFFE8F5E9),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: _getScrollViewSlivers(),
      ),
    );
  }

  //这个页面写的有点乱其实，后期可以考虑拆分一下
  List<Widget> _getScrollViewSlivers() {
    return [
      //用户基础信息
      SliverToBoxAdapter(
        child: Obx(() {
          //obx中必须又可监测的响应式数据
          if (_userController.loginInfo.value.userId.isNotEmpty) {
            return userInfo(isLogin: true);
          } else {
            return userInfo(isLogin: false);
          }
        }),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 10)),

      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            '功能区',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
      ),

      //功能方格
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return clickableWrapper(
              isDeveloping: true,
              route: "方格功能${index + 1}",
              child: featuresSquare(title: "功能${index + 1}"),
            );
          }, childCount: 12),
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 20)),

      //更多设置
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            '更多设置',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
      ),

      //线性布局功能条
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: clickableWrapper(
                isDeveloping: true,
                route: "条形功能${index + 1}",
                child: featuresLine(title: "条形功能${index + 1}"),
              ),
            );
          }, childCount: 10),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 100)), // 为悬浮导航栏留空
    ];
  }
}
