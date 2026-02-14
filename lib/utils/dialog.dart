import 'package:flutter/material.dart';

class MyDialog {
  /// 奶油绿风格的成功提示
  static void showSuccess(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF1F8E9), // 奶油绿背景
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
            SizedBox(width: 10),
            Text("修改成功", style: TextStyle(color: Color(0xFF2E7D32))),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("确定", style: TextStyle(color: Color(0xFF2E7D32))),
          ),
        ],
      ),
    );
  }

  /// 错误提示
  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("出错了"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("知道了", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
