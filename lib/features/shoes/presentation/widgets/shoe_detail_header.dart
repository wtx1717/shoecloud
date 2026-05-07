/// 渲染跑鞋详情顶部图片与基本信息。
import 'package:flutter/material.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class ShoeDetailHeader extends StatelessWidget {
  const ShoeDetailHeader({super.key, required this.shoe});

  final Shoe shoe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundSoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Hero(
                tag: 'shoe-${shoe.shoeId}',
                child: Image.network(
                  shoe.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.checkroom_rounded,
                    size: 72,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              shoe.nickname,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryDeep,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              shoe.shoeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
