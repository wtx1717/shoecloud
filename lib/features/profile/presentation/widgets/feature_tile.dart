/// 个人中心通用功能卡片。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.title,
    this.icon = Icons.extension_outlined,
    this.compact = false,
    this.routeName,
    this.arguments,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final bool compact;
  final String? routeName;
  final Map<String, dynamic>? arguments;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () => Get.toNamed(
                routeName ?? AppRoutes.comingSoon,
                arguments: arguments ?? {'title': title},
              ),
      child: AppCard(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 16,
          vertical: compact ? 14 : 16,
        ),
        child: compact
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: AppColors.primaryDeep, size: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: AppColors.primaryDeep, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
      ),
    );
  }
}
