import 'package:flutter/material.dart';
import 'package:shoecloud/nfc/writeToNFC.dart';

class bindNFCBottom extends StatefulWidget {
  final String shoeId;
  final String userId;
  const bindNFCBottom({super.key, required this.shoeId, required this.userId});

  @override
  State<bindNFCBottom> createState() => _bindNFCBottomState();
}

class _bindNFCBottomState extends State<bindNFCBottom> {
  @override
  Widget build(BuildContext context) {
    // 外层按钮：样式与“仅添加”按钮完全一致，实现视觉对称
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 12),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (BuildContext context) => _getShowModalBottomSheet(),
          );
        },
        child: Container(
          height: 55,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            "与 NFC 绑定",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 1. 中间态弹窗：用户点击“开始写入”后，在扫描完成前显示
  void _showNFCScanningDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // 允许点击外部取消，防止死循环
      builder: (context) => Center(
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Color(0xFF2E7D32),
                  strokeWidth: 5,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "请靠近 NFC 芯片",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "请将手机背部贴近芯片",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. 绑定成功后的最终提示弹窗
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE8F5E9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF2E7D32),
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              "绑定成功！",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 12),
            const Text("您的跑鞋已成功录入云端鞋库", textAlign: TextAlign.center),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                // 点击“太棒了”一键重置回首页，防止重复编辑
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "太棒了",
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. 底部 NFC 引导页逻辑
  Widget _getShowModalBottomSheet() {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.55,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          // 顶部装饰条
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "准备写入数据",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 10),
          const Text("请点击下方按钮并感应标签", style: TextStyle(color: Colors.grey)),

          const Spacer(),

          // 资源图片（如路径失效会显示占位图标）
          Image.asset(
            "lib/assets/home/bindNFC.png",
            height: 180,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) =>
                const Icon(Icons.nfc, size: 100, color: Colors.grey),
          ),

          const Spacer(),

          // 核心交互按钮：触发写入流程
          GestureDetector(
            onTap: () async {
              print("用户开启写入流程...");
              try {
                // 先关闭当前的引导底栏
                Navigator.pop(context);

                // 唤起扫描提醒弹窗（中间态）
                _showNFCScanningDialog();

                // 执行真正的 NFC 写入逻辑（这里会异步等待用户刷卡）
                await writeToNFC(widget.shoeId, widget.userId);

                // 写入成功后，关闭提醒弹窗
                if (mounted) Navigator.pop(context);

                // 弹出最终成功反馈
                if (mounted) _showSuccessDialog();
              } catch (e) {
                // 如果写入中止或报错，必须关闭提醒窗，否则会造成 UI 假死
                if (mounted) Navigator.pop(context);
                print("写入中止: $e");
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              height: 55,
              width: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "开始写入",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
