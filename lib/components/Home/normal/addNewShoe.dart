// 添加新跑鞋组件
import 'package:flutter/material.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';

class addNewShoe extends StatefulWidget {
  const addNewShoe({super.key});

  @override
  State<addNewShoe> createState() => _addNewShoeState();
}

class _addNewShoeState extends State<addNewShoe> {
  @override
  Widget build(BuildContext context) {
    return clickableWrapper(
      title: "添加新跑鞋",
      child: Image.asset(
        width: 50,
        height: 50,
        "lib/assets/home/addNewShoe.png",
      ),
    );
  }
}
