/// 浏览用于新增跑鞋流程的预置鞋库。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/features/shoes/domain/shoe_service.dart';
import 'package:shoecloud/features/shoes/models/shoe_catalog_item.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class ShoeCatalogPage extends StatefulWidget {
  const ShoeCatalogPage({super.key});

  @override
  State<ShoeCatalogPage> createState() => _ShoeCatalogPageState();
}

class _ShoeCatalogPageState extends State<ShoeCatalogPage> {
  final _service = Get.find<ShoeService>();
  late final Future<List<ShoeCatalogItem>> _future = _service.loadCatalog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('添加新跑鞋')),
      body: FutureBuilder<List<ShoeCatalogItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 1100
                  ? 4
                  : width >= 720
                  ? 3
                  : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      AppRoutes.catalogDetail,
                      arguments: {'item': item},
                    ),
                    child: AppCard(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              item.imagesUrl.isEmpty ? '' : item.imagesUrl.first,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.checkroom, size: 48),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
