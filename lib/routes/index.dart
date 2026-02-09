//管理路由
import 'package:flutter/material.dart';
import 'package:shoecloud/pages/Home/addNewShoe.dart';
import 'package:shoecloud/pages/Home/shoeInfo_User.dart';
import 'package:shoecloud/pages/Home/shoeInfo_add.dart';
import 'package:shoecloud/pages/Login/index.dart';
import 'package:shoecloud/pages/Main/index.dart';
import 'package:shoecloud/pages/Privacy/index.dart';
import 'package:shoecloud/pages/developing.dart';

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
    "/addNewShoe": (context) => addNewShoeView(), //添加新跑鞋路由
    "/shoeInfo_User": (context) => shoeInfo_UserView(), //鞋子详情页面路由
    "/shoeInfo_AddView": (context) => shoeInfo_AddView(), //添加新鞋子页面路由
    "/privacyPage": (context) => privacyPage(), //隐私政策页面路由
    "/developing": (context) => comingSoonView(), //开发中页面路由
  };
}
