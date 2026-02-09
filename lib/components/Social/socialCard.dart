//社区界面的几个卡片存在复用情况，单独抽离成组件
import 'package:flutter/material.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';

class socialCard extends StatefulWidget {
  final String title;
  final Widget content;

  const socialCard({super.key, required this.title, required this.content});

  @override
  State<socialCard> createState() => _socialCardState();
}

class _socialCardState extends State<socialCard> {
  @override
  Widget build(BuildContext context) {
    return clickableWrapper(route: "developing", child: _getSocialCard());
  }

  Widget _getSocialCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: Color.fromARGB(92, 125, 202, 237),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //内容部分
          Flexible(flex: 1, child: widget.content),
          //标题部分
          Flexible(
            flex: 1,
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
