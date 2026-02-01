// 添加新跑鞋组件
import 'package:flutter/material.dart';

class addNewShoe extends StatefulWidget {
  const addNewShoe({super.key});

  @override
  State<addNewShoe> createState() => _addNewShoeState();
}

class _addNewShoeState extends State<addNewShoe> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        print("添加新跑鞋");
      },
      icon: Image.asset(
        width: 50,
        height: 50,
        "lib/assets/home/addNewShoe.png",
      ),
    );
  }
}
