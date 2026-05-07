/// 承载新架构下的中英双语隐私政策页面。
import 'package:flutter/material.dart';
import 'package:shoecloud/features/privacy/presentation/widgets/policy_content.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool isChinese = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isChinese ? '隐私政策' : 'Privacy Policy'),
        actions: [
          IconButton(
            onPressed: () => setState(() => isChinese = !isChinese),
            icon: const Icon(Icons.translate),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.security, color: Color(0xFF2E7D32)),
                  Text(
                    isChinese ? '更新于 2025/12/16' : 'Updated 2025/12/16',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              PolicyContent(isChinese: isChinese),
            ],
          ),
        ),
      ),
    );
  }
}
