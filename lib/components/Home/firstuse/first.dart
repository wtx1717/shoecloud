// 首次使用绑定跑鞋组件
import 'package:flutter/material.dart';
import 'package:shoecloud/components/Home/normal/addNewShoeBottom.dart';

class firstUse extends StatefulWidget {
  const firstUse({super.key});

  @override
  State<firstUse> createState() => _firstUseState();
}

class _firstUseState extends State<firstUse> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AddNewShoe组件，放大两倍
          Transform.scale(scale: 2, child: addNewShoeBottom()),
          const SizedBox(height: 20),
          const Text(
            "欢迎使用云鞋库",
            style: TextStyle(
              color: Color.fromARGB(255, 120, 206, 164),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "从绑定第一双鞋子开始",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
