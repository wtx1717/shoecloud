/// 在个人中心顶部展示用户摘要信息。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<AppSessionController>();

    return Obx(() {
      if (!session.isLoggedIn || session.profile.value == null) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: AppCard(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primaryDeep,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '点击登录',
                        style: TextStyle(
                          color: AppColors.primaryDeep,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '登录后即可同步鞋库、活动与个人资料。',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  child: const Text('进入'),
                ),
              ],
            ),
          ),
        );
      }

      final base = session.profile.value!.baseInfo;
      final summary = session.profile.value!.accountSummary;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: AppCard(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primarySoft,
                    backgroundImage: base.avatarUrl.isNotEmpty
                        ? NetworkImage(base.avatarUrl)
                        : null,
                    child: base.avatarUrl.isEmpty
                        ? const Icon(
                            Icons.person_rounded,
                            color: AppColors.primaryDeep,
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          base.userName.isEmpty ? '未命名用户' : base.userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryDeep,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          base.account,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed(AppRoutes.profileEdit),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primaryDeep,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _StatPill(
                      label: '跑鞋',
                      value: '${summary.shoesCount}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatPill(
                      label: '活动',
                      value: '${summary.activityCount}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
