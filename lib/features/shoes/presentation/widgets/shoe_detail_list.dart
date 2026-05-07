/// 渲染跑鞋详情补充信息列表。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class ShoeDetailList extends StatelessWidget {
  const ShoeDetailList({super.key, required this.shoe});

  final Shoe shoe;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _Tile(label: '品牌', value: shoe.brand.isEmpty ? '未知' : shoe.brand),
          _Tile(label: '尺码', value: '${shoe.size} EUR'),
          _Tile(
            label: '购买价格',
            value: '¥${shoe.purchasePrice.toStringAsFixed(2)}',
          ),
          _Tile(
            label: '发售日期',
            value: shoe.releaseDate.isEmpty ? '未知' : shoe.releaseDate,
          ),
          _Tile(
            label: '绑定时间',
            value: shoe.bindTime.isEmpty ? '未知' : shoe.bindTime,
          ),
          _Tile(
            label: '当前状态',
            value: shoe.isRetired ? '已退役' : '使用中',
          ),
          _ActionTile(
            label: '活动记录',
            value: '查看全部',
            onTap: () => Get.toNamed(
              AppRoutes.activities,
              arguments: {'shoe': shoe},
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(color: AppColors.primaryDeep),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
