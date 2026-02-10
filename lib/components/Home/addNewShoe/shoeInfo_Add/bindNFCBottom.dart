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
    // 为了和“仅添加”按钮视觉对齐，这里使用相同的 Margin 和样式
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 12), // 底部留点间距给下一个按钮
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
          height: 55, // 高度统一为 55
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32), // 绑定按钮用深绿色，区分度更高
            borderRadius: BorderRadius.circular(20), // 圆角保持一致
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            "添加并与 NFC 绑定", // 统一文案风格
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

  // 绑定成功后的提示弹窗 (保持原样，但微调了关闭逻辑以适应 pushNamedAndRemoveUntil)
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
                // 这里的逻辑建议和“仅添加”保持一致，直接重置回首页
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

  // 底部 NFC 唤起弹窗 (保持逻辑不变，只做 UI 微调)
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
          // 如果没有图片会报错，请确保路径正确
          Image.asset(
            "lib/assets/home/bindNFC.png",
            height: 180,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) =>
                const Icon(Icons.nfc, size: 100, color: Colors.grey),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              try {
                await writeToNFC(widget.shoeId, widget.userId);
                if (mounted) {
                  Navigator.pop(context); // 关掉 BottomSheet
                  _showSuccessDialog(); // 弹成功窗
                }
              } catch (e) {
                print("写入失败: $e");
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              height: 55, // 这里也改为 55，保持整体统一
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
