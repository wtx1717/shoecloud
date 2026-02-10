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
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext context) => _getShowModalBottomSheet(),
        );
      },
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9C4), // 奶油黄主按钮
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "与 NFC 芯片绑定",
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  // 绑定成功后的提示弹窗
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
                Navigator.pop(context); // 关弹窗
                Navigator.pop(context); // 回到列表页
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

  // 底部 NFC 唤起弹窗
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
          const Text(
            "请将 NFC 标签靠近手机背部感应区",
            style: TextStyle(color: Colors.grey),
          ),

          const Spacer(),

          Image.asset(
            "lib/assets/home/bindNFC.png",
            height: 180,
            fit: BoxFit.contain,
          ),

          const Spacer(),

          GestureDetector(
            onTap: () async {
              print("用户开启写入流程...");
              try {
                await writeToNFC(widget.shoeId, widget.userId);
                if (mounted) {
                  Navigator.pop(context); // 关闭底部弹窗
                  _showSuccessDialog(); // 显示成功反馈
                }
              } catch (e) {
                print("写入中止: $e");
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              height: 70,
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
