import 'package:flutter/material.dart';
import 'package:shoecloud/components/Home/firstuse/first.dart';
import 'package:shoecloud/components/Home/normal/ShoeOverviewCard.dart';
import 'package:shoecloud/components/Home/normal/expandableCategoryBar.dart';

//这里View的含义表示这是首页视图而非Widget组件
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isFirstUse = false; //是否为首次使用

  //获取滚动组件
  List<Widget> _getScrollViewSlivers() {
    return [
      // 顶部分类栏悬停效果
      SliverFloatingHeader(child: expandableCategoryBar()),
      SliverToBoxAdapter(child: SizedBox(height: 10)),

      // 跑鞋概览卡片
      SliverToBoxAdapter(
        child: Column(
          children: List.generate(20, (int index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  //点击卡片跳转到跑鞋详情页
                  print("跳转到跑鞋${index + 1}详情页");
                },
                child: shoeOverviewCard(),
              ),
            );
          }),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return isFirstUse
        ? firstUse()
        : CustomScrollView(slivers: _getScrollViewSlivers());
  }
}
