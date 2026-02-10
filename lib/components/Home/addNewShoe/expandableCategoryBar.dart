import 'package:flutter/material.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';

class expandableCategoryBar extends StatefulWidget {
  const expandableCategoryBar({super.key});

  @override
  State<expandableCategoryBar> createState() => _ExpandableCategoryBarState();
}

class _ExpandableCategoryBarState extends State<expandableCategoryBar> {
  // 分类数据
  final List<List<String>> _list = [
    ['Nike', 'Adidas', 'Puma', '特步', '安踏', '361°'],
    ['2026', '2025', '2024', '2023', '2022', '2021', '2020'],
    ['训练', '慢跑', '竞速', '越野', '碳板'],
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      //展开折叠列表组件
      child: ExpansionTile(
        expandedAlignment: Alignment.bottomLeft,
        //左上角图标
        title: Image.asset(
          "lib/assets/home/more.png",
          width: 24,
          height: 24,
          alignment: AlignmentGeometry.centerLeft,
        ),

        initiallyExpanded: false, // 默认是否展开
        tilePadding: const EdgeInsets.only(left: 16),
        childrenPadding: EdgeInsets.zero,

        //展开后的子组件
        children: _getExpandedChildren(),
      ),
    ); // 展开后显示的横向分类列表
  }

  // 获取展开后的子组件
  List<Widget> _getExpandedChildren() {
    return List.generate(_list.length, (index) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              //分类项
              clickableWrapper(
                isDeveloping: true,
                route: 'null',
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9C4), // 奶油黄
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("分类项${index + 1}"),
                ),
              ),

              // 子分类列表
              Wrap(runSpacing: 10, children: _getWrapChildren(index)),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _getWrapChildren(int a) {
    return List.generate(_list[a].length, (b) {
      return clickableWrapper(
        isDeveloping: true,
        route: 'null',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F8E9), // 清新浅绿
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            _list[a][b],
            style: const TextStyle(color: Color(0xFF2E7D32)),
          ),
        ),
      );
    });
  }
}
