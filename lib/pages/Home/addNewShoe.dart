import 'package:flutter/material.dart';
import 'package:shoecloud/api/home.dart';
import 'package:shoecloud/viewmodels/home.dart';

class addNewShoe extends StatefulWidget {
  const addNewShoe({super.key});

  @override
  State<addNewShoe> createState() => _addNewShoeState();
}

class _addNewShoeState extends State<addNewShoe> {
  List<addShoeInfo> _list = [];

  @override
  void initState() {
    super.initState();
    _getList();
  }

  void _getList() async {
    _list = await getAddShoeInfoListAPI();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //该属性可以去掉左上角返回箭头
        //automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("添加新鞋"),
      ),
      body: Center(child: Text("添加新鞋")),
    );
  }
}
