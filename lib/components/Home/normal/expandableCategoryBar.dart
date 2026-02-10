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
    return Container(
      // 外部间距，让组件看起来像悬浮在背景上
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.06), // 淡淡的森林绿投影
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        // 去除 ExpansionTile 默认的边框和内边距线
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpansionTile(
          expandedAlignment: Alignment.bottomLeft,
          // 这里的 addNewShoeBottom 建议在其内部也保持圆润风格
          trailing: const addNewShoeBottom(),

          // 左侧图标：增加一点奶油黄底色感
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF9C4), // 标志性奶油黄
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "lib/assets/home/more.png",
                  width: 18,
                  height: 18,
                  color: const Color(0xFF2E7D32), // 统一为深绿图标
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "全部分类",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),

          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

          // 展开后的子组件
          children: _getExpandedChildren(),
        ),
      ),
    );
  }

  // 获取展开后的子组件
  List<Widget> _getExpandedChildren() {
    return [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.start,
        children: List.generate(categories.length, (index) {
          return clickableWrapper(
            isDeveloping: true,
            route: categories[index],
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                // 使用极浅绿背景
                color: const Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC8E6C9), width: 0.8),
              ),
              child: Text(
                categories[index],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32), // 统一森林绿
                ),
              ),
            ),
          );
        }),
      ),
    ];
  }
}
