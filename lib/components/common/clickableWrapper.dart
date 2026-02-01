import 'package:flutter/material.dart';

class clickableWrapper extends StatefulWidget {
  final String title;
  final Widget child;

  const clickableWrapper({super.key, required this.title, required this.child});

  @override
  State<clickableWrapper> createState() => _clickableWrapperState();
}

class _clickableWrapperState extends State<clickableWrapper> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("点击了${widget.title}组件");
      },
      child: widget.child,
    );
  }
}
