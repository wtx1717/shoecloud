//这个页面写的有点乱其实，后期可以考虑拆分一下
import 'package:flutter/material.dart';
import 'package:shoecloud/components/My/featuresLine.dart';
import 'package:shoecloud/components/My/featuresSquare.dart';
import 'package:shoecloud/components/My/userInfo.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';

class MyView extends StatefulWidget {
  const MyView({super.key});

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: _getScrollViewSlivers());
  }

  List<Widget> _getScrollViewSlivers() {
    return [
      //用户基础信息
      SliverToBoxAdapter(child: userInfo()),
      SliverToBoxAdapter(child: SizedBox(height: 10)),

      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            '功能区',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      //功能方格
      SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 1,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return clickableWrapper(
              route: "方格功能${index + 1}",
              child: featuresSquare(title: "方格功能${index + 1}"),
            );
          }, childCount: 12),
        ),
      ),

      //更多设置
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            '更多设置',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      //线性布局功能条
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return clickableWrapper(
            route: "条形功能${index + 1}",
            child: featuresLine(title: "条形功能${index + 1}"),
          );
        }, childCount: 10),
      ),
    ];
  }
}
