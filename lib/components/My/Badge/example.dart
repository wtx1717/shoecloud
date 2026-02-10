//这是一个徽章的示例代码
import 'package:flutter/material.dart';

class BetaBadge extends StatelessWidget {
  const BetaBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4), // 改为奶油黄
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: const Text(
        '内测用户',
        style: TextStyle(
          color: Color(0xFF2E7D32), // 改为森林绿字
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
