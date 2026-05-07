/// 构建带统一主题和路由的应用根节点。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_pages.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/app/theme/app_theme.dart';

class ShoeCloudApp extends StatelessWidget {
  const ShoeCloudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShoeCloud',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.root,
      getPages: AppPages.routes,
    );
  }
}
