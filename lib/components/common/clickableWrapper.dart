import 'package:flutter/material.dart';
import 'package:shoecloud/components/common/showComingSoonDialog.dart';

// 一个通用的可点击包装器，用于将任意子组件包装为可点击并进行路由跳转。
// - `route` 是目标命名路由的路径（不含前导斜杠）。
// - `arguments` 是可选参数，会通过 Navigator.pushNamed 的 arguments 传递给目标路由。
class clickableWrapper extends StatefulWidget {
  final String route;
  final Widget child;
  final Object? arguments;
  final bool isDeveloping;

  const clickableWrapper({
    super.key,
    required this.route,
    required this.child,
    this.isDeveloping = false,
    this.arguments,
  });

  @override
  State<clickableWrapper> createState() => _clickableWrapperState();
}

class _clickableWrapperState extends State<clickableWrapper> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 点击时进行命名路由跳转，并将 `arguments` 传入目标页面。
        // 目标页面可以通过 `ModalRoute.of(context)?.settings.arguments` 读取这些参数。
        if (widget.isDeveloping) {
          showComingSoonDialog(context);
        } else {
          Navigator.pushNamed(
            context,
            "/${widget.route}",
            arguments: widget.arguments,
          );
        }
        print("点击了${widget.route}组件，参数：${widget.arguments}");
      },
      child: widget.child,
    );
  }
}
