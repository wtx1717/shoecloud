//管理路由
import 'package:flutter/material.dart';
import 'package:shoecloud/pages/Home/addNewShoe.dart';
import 'package:shoecloud/pages/Home/shoeInfo.dart';
import 'package:shoecloud/pages/Login/index.dart';
import 'package:shoecloud/pages/Main/index.dart';

//返回App根级组件
Widget getRootWidget() {
  return MaterialApp(
    //命名路由
    initialRoute: "/",
    routes: getRootRoutes(),
  );
}

//返回根级路由表
Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {
    "/": (context) => MainPage(), //主页路由
    "/login": (context) => LoginPage(), //登录页路由
    "/addNewShoe": (context) => addNewShoe(), //添加新跑鞋路由
    "/shoeInfo": (context) => shoeInfo(), //鞋子详情页面路由
  };
}
