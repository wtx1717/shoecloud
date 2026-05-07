/// 启动应用，并接入新的模块化架构主链路。
import 'package:flutter/material.dart';
import 'package:shoecloud/app/app_bootstrap.dart';
import 'package:shoecloud/app/shoecloud_app.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const ShoeCloudApp());
}
