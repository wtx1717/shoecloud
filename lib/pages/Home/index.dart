import 'package:flutter/material.dart';

//这里View的含义表示这是首页视图而非Widget组件
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("首页视图"));
  }
}
