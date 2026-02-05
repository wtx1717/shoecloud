import 'package:flutter/material.dart';

class shoeInfo_UserView extends StatefulWidget {
  const shoeInfo_UserView({super.key});

  @override
  State<shoeInfo_UserView> createState() => _shoeInfo_UserViewState();
}

class _shoeInfo_UserViewState extends State<shoeInfo_UserView> {
  @override
  Widget build(BuildContext context) {
    // 从 ModalRoute 的 settings 中读取命名路由传入的 arguments。
    // 我们支持两种形态的参数：
    // 1) Map 形式（例如 {"shoeId": 3}） — 推荐形式，便于以后扩展字段；
    // 2) 直接传入 int（例如 3） — 兼容老代码或简单场景。
    final args = ModalRoute.of(context)?.settings.arguments;
    int? shoeId;
    if (args is Map && args['shoeId'] is int) {
      shoeId = args['shoeId'] as int;
    } else if (args is int) {
      shoeId = args;
    }

    return Scaffold(
      appBar: AppBar(title: Text("鞋子详情页面"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Text(
            shoeId != null ? "鞋子详情页面 - id: $shoeId" : "鞋子详情页面 - 未传入id",
          ),
        ),
      ),
    );
  }
}
