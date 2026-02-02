import 'package:flutter/material.dart';
import 'package:shoecloud/components/Home/firstuse/first.dart';
import 'package:shoecloud/components/Home/normal/ShoeOverviewCard.dart';
import 'package:shoecloud/components/Home/normal/expandableCategoryBar.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';

//这里View的含义表示这是首页视图而非Widget组件
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isFirstUse = false; //是否为首次使用

  @override
  Widget build(BuildContext context) {
    return isFirstUse
        ? firstUse()
        : CustomScrollView(slivers: _getScrollViewSlivers());
  }

  //获取滚动组件
  List<Widget> _getScrollViewSlivers() {
    return [
      // 顶部分类栏悬停效果
      SliverFloatingHeader(child: expandableCategoryBar()),
      SliverToBoxAdapter(child: SizedBox(height: 10)),

      // 跑鞋概览卡片
      // 使用 SliverList 实现懒加载
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return clickableWrapper(
            title: "跑鞋${index + 1}",
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: shoeOverviewCard(),
            ),
          );
        }, childCount: 20),
      ),
    ];
  }
}
