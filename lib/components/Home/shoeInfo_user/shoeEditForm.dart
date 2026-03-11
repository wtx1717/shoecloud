import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shoecloud/api/shoeInfo.dart';
import 'package:shoecloud/stores/userController.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

class shoeEditForm extends StatefulWidget {
  final ShoeInfo shoe;
  const shoeEditForm({super.key, required this.shoe});

  @override
  State<shoeEditForm> createState() => _shoeEditFormState();
}

class _shoeEditFormState extends State<shoeEditForm> {
  // 控制器
  late TextEditingController _nicknameController;
  late TextEditingController _sizeController;
  late TextEditingController _priceController;
  late bool _isRetired;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.shoe.nickname);
    _sizeController = TextEditingController(text: widget.shoe.size.toString());
    _priceController = TextEditingController(text: widget.shoe.purchasePrice.toString());
    _isRetired = widget.shoe.isRetired;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 1. 修改图片卡片 (风格延续 GridItem)
          _buildImagePicker(),
          const SizedBox(height: 20),

          // 2. 编辑表单组
          _buildInputCard("跑鞋昵称", _nicknameController, Icons.label_important_outline),
          _buildInputCard("尺码 (EUR)", _sizeController, Icons.straighten, isNumber: true),
          _buildInputCard("购入价格 (¥)", _priceController, Icons.payments_outlined, isNumber: true),
          
          // 3. 退休开关
          _buildSwitchCard(),
          const SizedBox(height: 30),

          // 4. 操作按钮组
          _buildActionButtons(),
        ],
      ),
    );
  }

  // 构建图片选择预览
  Widget _buildImagePicker() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4).withOpacity(0.5), // 延续你的淡黄风格
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow.shade200),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(widget.shoe.imageUrl, height: 120, fit: BoxFit.cover),
          ),
          TextButton.icon(
            onPressed: () { /* TODO: 调用图片上传逻辑 */ },
            icon: const Icon(Icons.photo_camera, size: 18, color: Colors.brown),
            label: const Text("更换照片", style: TextStyle(color: Colors.brown)),
          )
        ],
      ),
    );
  }

  // 通用输入卡片
  Widget _buildInputCard(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F5E9)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(icon, size: 20, color: Colors.green[700]),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // 退休开关卡片
  Widget _buildSwitchCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isRetired ? Colors.grey[200] : const Color(0xFFE8F5E9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.power_settings_new, color: _isRetired ? Colors.grey : Colors.green),
              const SizedBox(width: 12),
              Text(_isRetired ? "这双鞋已退役" : "服役中", style: TextStyle(color: Colors.green[900])),
            ],
          ),
          Switch(
            value: _isRetired,
            activeColor: Colors.green[700],
            onChanged: (val) => setState(() => _isRetired = val),
          )
        ],
      ),
    );
  }

  // 底部按钮：保存与删除
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            // 指向保存逻辑
            onPressed: _handleSave, 
            child: const Text("保存修改", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          // 指向删除逻辑
          onPressed: _handleDelete,
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          label: const Text("删除这双跑鞋", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  // 1. 完善保存修改逻辑
  Future<void> _handleSave() async {
    // 封装前端修改后的字段
    final Map<String, dynamic> newInfo = {
      "nickname": _nicknameController.text,
      "size": double.tryParse(_sizeController.text) ?? widget.shoe.size,
      "purchase_price": double.tryParse(_priceController.text) ?? widget.shoe.purchasePrice,
      "is_retired": _isRetired,
    };

    // 调用 API 更新
    bool success = await updateShoeDetailAPI(
      userId: Get.find<UserController>().loginInfo.value.userId,
      shoeId: widget.shoe.shoeId,
      newInfo: newInfo,
    );

    if (success) {
      _onOperationFinish(title: "更新成功", msg: "跑鞋信息更新成功！", isDeleted: false);
    }
  }

  // 2. 完善删除跑鞋逻辑
  Future<void> _handleDelete() async {
    // 弹出确认对话框
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("确认删除"),
        content: const Text("删除后跑鞋数据将永久移除，确定吗？"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("取消")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text("确定", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await deleteShoeAPI(
        userId: Get.find<UserController>().loginInfo.value.userId,
        shoeId: widget.shoe.shoeId,
      );

      if (success) {
        _onOperationFinish(title: "删除成功", msg: "跑鞋已成功移除。", isDeleted: true);
      }
    }
  }

  // 3. 辅助方法：操作成功后的统一跳转刷新
  void _onOperationFinish({required String title, required String msg, bool isDeleted = false}) async {
    // 1. 依然保持全局刷新的习惯，确保首页同步
    await Get.find<UserController>().refreshUserInfo();
  
    if (!mounted) return;
  
    // 2. 弹出你要求的风格弹窗
    _showStatusDialog(
      title: title,
      message: msg,
      icon: isDeleted ? Icons.delete_sweep : Icons.check_circle_outline,
      onConfirm: () {
        if (isDeleted) {
          // 如果是删除，直接回首页并清空路由栈
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        } else {
          // 【核心修改】：如果是编辑成功，返回 true 给上一个页面（详情页）
          // 这样详情页的 Navigator.pushNamed 就会收到这个 true
          Navigator.of(context).pop(true); 
        }
      },
    );
  }

  void _showStatusDialog({
    required String title,
    required String message,
    required IconData icon,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // 强制用户点击确认
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: const Color(0xFFE8F5E9), 
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF9C4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: const Color(0xFF2E7D32)),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 关弹窗
                      onConfirm(); // 执行后续跳转逻辑
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("确 定", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
