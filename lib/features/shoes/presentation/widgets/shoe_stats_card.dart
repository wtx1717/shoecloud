/// 渲染跑鞋详情页统计网格。
import 'package:flutter/material.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';
import 'package:shoecloud/shared/utils/time_formatter.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class ShoeStatsCard extends StatelessWidget {
  const ShoeStatsCard({super.key, required this.shoe});

  final Shoe shoe;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
        children: [
          _StatItem(
            label: '总里程',
            value: '${shoe.stats.totalMileage.toStringAsFixed(1)} km',
          ),
          _StatItem(
            label: '总时长',
            value: TimeFormatter.formatDuration(shoe.stats.totalDuration),
          ),
          _StatItem(label: '使用次数', value: '${shoe.stats.usageCount} 次'),
          _StatItem(
            label: '最长单次',
            value: '${shoe.stats.maxSingleDistance.toStringAsFixed(1)} km',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
