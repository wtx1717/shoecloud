/// 在新跑鞋模块中编辑或删除已有跑鞋。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/features/home/presentation/controllers/home_controller.dart';
import 'package:shoecloud/features/shoes/domain/shoe_service.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';
import 'package:shoecloud/shared/widgets/app_feedback.dart';
import 'package:shoecloud/shared/widgets/app_primary_button.dart';

class ShoeEditPage extends StatefulWidget {
  const ShoeEditPage({super.key});

  @override
  State<ShoeEditPage> createState() => _ShoeEditPageState();
}

class _ShoeEditPageState extends State<ShoeEditPage> {
  final _service = Get.find<ShoeService>();
  final _homeController = Get.find<HomeController>();
  late final Shoe _shoe;
  late final TextEditingController _nicknameController;
  late final TextEditingController _sizeController;
  late final TextEditingController _priceController;
  late bool _isRetired;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    _shoe = args['shoe'] as Shoe;
    _nicknameController = TextEditingController(text: _shoe.nickname);
    _sizeController = TextEditingController(text: _shoe.size.toString());
    _priceController = TextEditingController(
      text: _shoe.purchasePrice.toString(),
    );
    _isRetired = _shoe.isRetired;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('编辑跑鞋信息')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              children: [
                Image.network(
                  _shoe.imageUrl,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.checkroom, size: 52),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(labelText: '跑鞋昵称'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _sizeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: '尺码 (EUR)'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: '购买价格'),
                ),
                const SizedBox(height: 14),
                SwitchListTile(
                  value: _isRetired,
                  onChanged: (value) => setState(() => _isRetired = value),
                  title: const Text('已退役'),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: _submitting ? '保存中...' : '保存修改',
            onPressed: _submitting ? null : _save,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _submitting ? null : _delete,
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            label: const Text(
              '删除这双跑鞋',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _submitting = true);
    final success = await _service.updateShoe(
      shoe: _shoe,
      nickname: _nicknameController.text.trim(),
      size: double.tryParse(_sizeController.text) ?? _shoe.size,
      purchasePrice: double.tryParse(_priceController.text) ?? _shoe.purchasePrice,
      isRetired: _isRetired,
    );
    if (!mounted) {
      return;
    }

    setState(() => _submitting = false);
    if (success) {
      await _homeController.refreshAll();
      AppFeedback.showSuccess(context, '更新成功');
      Get.back(result: true);
    } else {
      AppFeedback.showError(context, '更新失败');
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('删除后将永久移除这双跑鞋及其相关数据。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    setState(() => _submitting = true);
    final success = await _service.deleteShoe(_shoe);
    if (!mounted) {
      return;
    }

    setState(() => _submitting = false);
    if (success) {
      await _homeController.refreshAll();
      AppFeedback.showSuccess(context, '删除成功');
      Get.until(
        (route) => route.settings.name == AppRoutes.root || route.isFirst,
      );
    } else {
      AppFeedback.showError(context, '删除失败');
    }
  }
}
