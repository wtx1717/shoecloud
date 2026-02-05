// 顶部分类栏组件
import 'package:flutter/material.dart';
import 'package:shoecloud/components/Home/normal/addNewShoeBottom.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';

// ignore: camel_case_types
class expandableCategoryBar extends StatefulWidget {
  const expandableCategoryBar({super.key});

  @override
  State<expandableCategoryBar> createState() => _ExpandableCategoryBarState();
}

class _ExpandableCategoryBarState extends State<expandableCategoryBar> {
  // 分类数据
  final List<String> categories = ['我的最爱', '慢跑鞋', '碳板鞋', '越野鞋'];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      //展开折叠列表组件
      child: ExpansionTile(
        expandedAlignment: Alignment.bottomLeft,
        trailing: addNewShoeBottom(),
        //左上角图标
        title: Image.asset(
          "lib/assets/home/more.png",
          width: 24,
          height: 24,
          alignment: AlignmentGeometry.centerLeft,
        ),

        initiallyExpanded: false, // 默认是否展开
        tilePadding: EdgeInsets.only(left: 16),
        childrenPadding: EdgeInsets.zero,

        //展开后的子组件
        children: _getExpandedChildren(),
      ),
    ); // 展开后显示的横向分类列表
  }

  // 获取展开后的子组件
  List<Widget> _getExpandedChildren() {
    return [
      Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start, // 左对齐
        children: List.generate(categories.length, (index) {
          return clickableWrapper(
            route: categories[index],
            child: Container(
              height: 36,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[800], // 深绿色文字
                ),
              ),
            ),
          );
        }),
      ),
    ];
  }
}
