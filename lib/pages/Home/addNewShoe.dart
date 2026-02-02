import 'package:flutter/material.dart';

class addNewShoe extends StatefulWidget {
  const addNewShoe({super.key});

  @override
  State<addNewShoe> createState() => _addNewShoeState();
}

class _addNewShoeState extends State<addNewShoe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //该属性可以去掉左上角返回箭头
        //automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("添加新鞋"),
      ),
      body: Center(child: Text("这是添加跑鞋页面")),
    );
  }
}
