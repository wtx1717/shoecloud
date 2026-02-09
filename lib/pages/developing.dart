import 'package:flutter/material.dart';

class comingSoonView extends StatefulWidget {
  final String title;
  const comingSoonView({super.key, this.title = "功能开发中"});

  @override
  State<comingSoonView> createState() => _comingSoonViewState();
}

class _comingSoonViewState extends State<comingSoonView> {
  // 配色方案（与首页保持一致）
  final Color primaryGreen = const Color(0xFFE8F5E9);
  final Color darkGreen = const Color(0xFF2E7D32);
  final Color accentYellow = const Color(0xFFFFF9C4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkGreen),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 中心装饰物：带淡黄色光晕的图标
            _buildAnimatedIcon(),
            const SizedBox(height: 40),

            // 提示文字
            Text(
              "COMING SOON",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: darkGreen.withOpacity(0.8),
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: accentYellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "该功能正在全力打磨中，敬请期待",
                style: TextStyle(
                  color: Colors.brown[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 60),

            // 返回按钮
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text("返回上一页", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // 内部小组件：构建一个有层次感的装饰图标
  Widget _buildAnimatedIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 背景光晕
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: accentYellow.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        ),
        // 运动小图标
        Icon(
          Icons.auto_awesome, // 或者使用 Icons.construction / Icons.rocket_launch
          size: 80,
          color: darkGreen,
        ),
      ],
    );
  }
}
