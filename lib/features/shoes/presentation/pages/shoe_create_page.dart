/// 在加入鞋库前补全本地跑鞋信息。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/features/home/presentation/controllers/home_controller.dart';
import 'package:shoecloud/features/shoes/domain/shoe_service.dart';
import 'package:shoecloud/features/shoes/models/shoe_catalog_item.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';
import 'package:shoecloud/shared/widgets/app_feedback.dart';
import 'package:shoecloud/shared/widgets/app_primary_button.dart';

class ShoeCreatePage extends StatefulWidget {
  const ShoeCreatePage({super.key});

  @override
  State<ShoeCreatePage> createState() => _ShoeCreatePageState();
}

class _ShoeCreatePageState extends State<ShoeCreatePage> {
  final _service = Get.find<ShoeService>();
  final _homeController = Get.find<HomeController>();
  final _nicknameController = TextEditingController();
  final _sizeController = TextEditingController(text: '42.5');
  final _priceController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final item = args['item'] as ShoeCatalogItem;

    if (_nicknameController.text.isEmpty) {
      _nicknameController.text = item.name;
      _priceController.text = item.releasePrice.toString();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('完善跑鞋信息')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
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
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: _submitting ? '添加中...' : '添加这双跑鞋',
            onPressed: _submitting ? null : () => _submit(item),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(ShoeCatalogItem item) async {
    setState(() => _submitting = true);
    final success = await _service.addFromCatalog(
      item: item,
      nickname: _nicknameController.text.trim(),
      size: double.tryParse(_sizeController.text) ?? 42.5,
      purchasePrice: double.tryParse(_priceController.text) ?? 0,
    );
    if (!mounted) {
      return;
    }

    setState(() => _submitting = false);

    if (success) {
      await _homeController.refreshAll();
      AppFeedback.showSuccess(context, '添加成功');
      Get.until(
        (route) => route.settings.name == AppRoutes.root || route.isFirst,
      );
    } else {
      AppFeedback.showError(context, '添加失败，请稍后重试');
    }
  }
}
