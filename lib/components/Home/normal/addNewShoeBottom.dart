// 添加新跑鞋组件
import 'package:flutter/material.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';

class addNewShoeBottom extends StatefulWidget {
  const addNewShoeBottom({super.key});

  @override
  State<addNewShoeBottom> createState() => _addNewShoeBottomState();
}

class _addNewShoeBottomState extends State<addNewShoeBottom> {
  @override
  Widget build(BuildContext context) {
    return clickableWrapper(
      route: "addNewShoe",
      child: Image.asset(
        width: 50,
        height: 50,
        "lib/assets/home/addNewShoe.png",
      ),
    );
  }
}
