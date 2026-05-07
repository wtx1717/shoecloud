/// 在加入个人鞋库前展示预置鞋款详情。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/features/shoes/models/shoe_catalog_item.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';
import 'package:shoecloud/shared/widgets/app_primary_button.dart';

class ShoeCatalogDetailPage extends StatelessWidget {
  const ShoeCatalogDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final item = args['item'] as ShoeCatalogItem;

    return Scaffold(
      appBar: AppBar(title: const Text('跑鞋详情')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 240,
                    child: PageView(
                      children: item.imagesUrl
                          .map(
                            (url) => Image.network(
                              url,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.checkroom, size: 80),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(item.brand, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Text(item.description),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.features
                        .map((feature) => Chip(label: Text(feature)))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppPrimaryButton(
              label: '添加这双跑鞋',
              onPressed: () => Get.toNamed(
                AppRoutes.createShoe,
                arguments: {'item': item},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
