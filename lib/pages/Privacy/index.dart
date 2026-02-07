import 'package:flutter/material.dart';
import 'package:shoecloud/pages/Privacy/policyContent.dart';

class privacyPage extends StatefulWidget {
  const privacyPage({super.key});

  @override
  State<privacyPage> createState() => _privacyPageState();
}

// 符合规范：lowerCamelCase 类名
class _privacyPageState extends State<privacyPage> {
  bool isChinese = true;

  void toggleLanguage() {
    setState(() {
      isChinese = !isChinese;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7), // 抹茶奶油浅黄
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFC5E1A5), // 抹茶绿
        title: Text(
          isChinese ? "隐私政策" : "Privacy Policy",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            onPressed: toggleLanguage,
            icon: const Icon(Icons.translate),
            tooltip: isChinese ? "Switch to English" : "切换为中文",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顶部状态条
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.security,
                      color: Color(0xFF81C784),
                      size: 30,
                    ),
                    Text(
                      isChinese ? "更新于 2025/12/16" : "Updated 2025/12/16",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                // 引用外部文本组件
                policyContent(isChinese: isChinese),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
