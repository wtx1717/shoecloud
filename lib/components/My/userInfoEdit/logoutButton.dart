import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/stores/tokenManager.dart';
import 'package:shoecloud/stores/userController.dart';
import 'package:shoecloud/viewmodels/userInfo.dart';
import 'package:shoecloud/viewmodels/userLogin.dart';

class logoutButton extends StatefulWidget {
  final VoidCallback? onConfirm;
  const logoutButton({super.key, this.onConfirm});

  @override
  State<logoutButton> createState() => _logoutButtonState();
}

class _logoutButtonState extends State<logoutButton> {
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildMainButton(context));
  }

  // 1. 构建最外层的退出按钮
  Widget _buildMainButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      width: double.infinity,
      height: 55,
      child: TextButton(
        onPressed: () => _showConfirmDialog(context),
        style: _buttonStyle(),
        child: _buttonText(),
      ),
    );
  }

  // 2. 按钮样式抽离
  ButtonStyle _buttonStyle() {
    return TextButton.styleFrom(
      backgroundColor: const Color(0xFFFFEBEE), // 极其淡的红色背景
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // 保持和上方卡片一致的圆角
        side: const BorderSide(color: Color(0xFFFFCDD2), width: 1), // 浅色边框增强精致感
      ),
    );
  }

  // 3. 按钮文字抽离
  Widget _buttonText() {
    return const Text(
      "退出登录",
      style: TextStyle(
        color: Color(0xFFD32F2F), // 警告红
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0, // 字间距拉开，更具高级感
      ),
    );
  }

  // 4. 弹窗触发逻辑
  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildDialogContent(context),
    );
  }

  // 5. 构建弹窗内容外壳
  Widget _buildDialogContent(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(),
              _buildDialogBody(),
              const SizedBox(height: 30),
              _buildDialogActions(context),
            ],
          ),
        ),
      ),
    );
  }

  // 6. 弹窗头部图标
  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Color(0xFFFFEBEE),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.logout_rounded,
        color: Color(0xFFD32F2F),
        size: 30,
      ),
    );
  }

  // 7. 弹窗文字信息
  Widget _buildDialogBody() {
    return const Column(
      children: [
        SizedBox(height: 20),
        Text(
          "确认退出",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "退出后将无法接收云端同步信息\n确定要离开吗？",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // 8. 弹窗操作按钮组
  Widget _buildDialogActions(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          label: "再想想",
          color: Colors.grey[100]!,
          textColor: Colors.grey,
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(width: 15),
        _buildActionButton(
          label: "退出登录",
          color: const Color(0xFFD32F2F),
          textColor: Colors.white,
          onTap: () async {
            // --- 退出逻辑核心区 ---

            //删除本地持久化的 token 和登录信息
            await tokenManager.removeLoginInfo();

            //删除Getx内存数据
            _userController.updateuserLogin(userLogin.formJSON({}));
            _userController.updateFullInfo(UserInfoModel.formJSON({}));
            //关闭确认对话框
            if (mounted) Navigator.pop(context);
            Navigator.pop(context);
            // 3. 执行外部传入的数据清除和页面跳转逻辑 (Getx 内存清除等)
            if (widget.onConfirm != null) widget.onConfirm!();
          },
        ),
      ],
    );
  }

  // 9. 原子级按钮组件
  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
