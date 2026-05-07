/// 渲染活动同步操作卡片。
import 'package:flutter/material.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class SyncActionCard extends StatelessWidget {
  const SyncActionCard({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AppCard(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        color: AppColors.accentSoft,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: AppColors.primaryDeep,
                        ),
                      )
                    : const Icon(
                        Icons.sync_rounded,
                        color: AppColors.primaryDeep,
                      ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '活动同步',
                    style: TextStyle(
                      color: AppColors.primaryDeep,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '将待处理的运动记录关联到当前跑鞋。',
                    style: TextStyle(color: AppColors.textMuted, height: 1.5),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          ],
        ),
      ),
    );
  }
}
