/// 渲染首页顶部欢迎区与数据概览。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/home/presentation/controllers/home_controller.dart';
import 'package:shoecloud/features/home/presentation/widgets/add_shoe_entry_button.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<AppSessionController>();
    final controller = Get.find<HomeController>();
    final profile = session.profile.value;
    final userName = profile?.baseInfo.userName.trim().isNotEmpty == true
        ? profile!.baseInfo.userName
        : 'Runner';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '您好，$userName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primaryDeep,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '今天也要好好跑步',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primaryDeep,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: '跑鞋数量',
                    value: '${profile?.accountSummary.shoesCount ?? 0}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatBox(
                    label: '活动次数',
                    value: '${profile?.accountSummary.activityCount ?? 0}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatBox(
                    label: '已加载',
                    value: '${controller.shoes.length}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerRight,
              child: AddShoeEntryButton(label: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryDeep,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
