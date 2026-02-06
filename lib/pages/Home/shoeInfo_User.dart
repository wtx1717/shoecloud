import 'package:flutter/material.dart';

// 用户查看鞋子详情信息的界面
class shoeInfo_UserView extends StatefulWidget {
  const shoeInfo_UserView({super.key});

  @override
  State<shoeInfo_UserView> createState() => _shoeInfo_UserViewState();
}

// 管理用户查看鞋子详情信息界面状态的类
class _shoeInfo_UserViewState extends State<shoeInfo_UserView> {
  @override
  Widget build(BuildContext context) {
    // 获取包裹
    final args = ModalRoute.of(context)?.settings.arguments;
    print('【详情页调试】收到的 arguments 类型: ${args.runtimeType}, 内容: $args');

    String? shoeId;

    // 增强型解析逻辑
    if (args != null) {
      if (args is Map) {
        shoeId = args['shoeId'];
      } else {
        // 如果 arguments 直接就是 "123" 这种字符串或数字
        shoeId = args.toString();
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("鞋子详情页面"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Text(
            shoeId != null
                ? "鞋子详情页面 - id: $shoeId"
                : "未识别到 ID (收到的原始数据: $args)",
          ),
        ),
      ),
    );
  }
}
