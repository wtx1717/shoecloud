/// 展示社区 Tab 中的静态内容入口卡片。
import 'package:flutter/material.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/social/presentation/widgets/social_card.dart';
import 'package:shoecloud/shared/widgets/app_shell.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _SocialIntro()),
          SliverToBoxAdapter(
            child: SocialCard(
              title: '跑鞋评测',
              assetPath: 'lib/assets/social/shoeReviews.png',
            ),
          ),
          SliverToBoxAdapter(
            child: SocialCard(
              title: '鞋款知识',
              assetPath: 'lib/assets/social/shoeKnowledge.png',
            ),
          ),
          SliverToBoxAdapter(
            child: SocialCard(
              title: '开源社区',
              assetPath: 'lib/assets/social/openSource.png',
            ),
          ),
          SliverToBoxAdapter(
            child: SocialCard(
              title: '更多内容',
              assetPath: 'lib/assets/social/more.png',
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _SocialIntro extends StatelessWidget {
  const _SocialIntro();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '探索内容',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '用更克制的视觉方式保留社区入口，后续再继续扩展真实内容流。',
            style: TextStyle(
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
