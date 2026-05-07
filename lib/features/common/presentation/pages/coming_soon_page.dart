/// 用于承接暂未完成路由的通用占位页。
import 'package:flutter/material.dart';
import 'package:shoecloud/shared/widgets/app_empty_state.dart';
import 'package:shoecloud/shared/widgets/app_shell.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, this.title = '功能开发中'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const AppShell(
        child: AppEmptyState(
          title: 'Coming Soon',
          subtitle: '这一部分能力还在打磨中，当前版本先保留入口。',
          icon: Icons.auto_awesome,
        ),
      ),
    );
  }
}
