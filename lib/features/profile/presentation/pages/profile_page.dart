/// 渲染个人中心页。
import 'package:flutter/material.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/profile/presentation/widgets/feature_tile.dart';
import 'package:shoecloud/features/profile/presentation/widgets/profile_header.dart';
import 'package:shoecloud/shared/widgets/app_shell.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: ProfileHeader()),
          const SliverToBoxAdapter(child: _SectionTitle(title: '功能区')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildListDelegate.fixed(const [
                FeatureTile(
                  title: '编辑资料',
                  compact: true,
                  icon: Icons.edit_note_outlined,
                  routeName: AppRoutes.profileEdit,
                ),
                FeatureTile(
                  title: '隐私政策',
                  compact: true,
                  icon: Icons.privacy_tip_outlined,
                  routeName: AppRoutes.privacy,
                ),
                FeatureTile(
                  title: '跑鞋档案',
                  compact: true,
                  icon: Icons.checkroom_outlined,
                ),
                FeatureTile(
                  title: '活动同步',
                  compact: true,
                  icon: Icons.sync_outlined,
                ),
                FeatureTile(
                  title: '标签管理',
                  compact: true,
                  icon: Icons.sell_outlined,
                ),
                FeatureTile(
                  title: '设备连接',
                  compact: true,
                  icon: Icons.devices_other_outlined,
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),
          const SliverToBoxAdapter(child: _SectionTitle(title: '更多设置')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed(const [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: FeatureTile(
                    title: '账号与安全',
                    icon: Icons.lock_outline,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: FeatureTile(
                    title: '通知设置',
                    icon: Icons.notifications_none_outlined,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: FeatureTile(
                    title: '数据与同步',
                    icon: Icons.cloud_sync_outlined,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: FeatureTile(
                    title: '关于项目',
                    icon: Icons.info_outline,
                  ),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryDeep,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
