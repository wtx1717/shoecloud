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
    // 统一路由到开发中页面
    return clickableWrapper(route: "developing", child: _getSocialCard());
  }

  Widget _getSocialCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      width: double.infinity,
      height: 180, // 稍微缩小高度，让页面更清爽
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30), // 超大圆角
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // 背景装饰：奶油黄的小圆圈，增加设计感
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Row(
              children: [
                // 1. 内容/插图部分
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: widget.content,
                  ),
                ),

                // 2. 标题部分
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.title,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2E7D32), // 标志性深绿
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 装饰小线条
                        Container(
                          width: 30,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9C4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
