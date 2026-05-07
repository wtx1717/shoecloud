/// 展示首页跑鞋总览与空状态。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/features/home/presentation/controllers/home_controller.dart';
import 'package:shoecloud/features/home/presentation/widgets/add_shoe_entry_button.dart';
import 'package:shoecloud/features/home/presentation/widgets/home_header.dart';
import 'package:shoecloud/features/home/presentation/widgets/shoe_overview_card.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/shared/widgets/app_empty_state.dart';
import 'package:shoecloud/shared/widgets/app_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<AppSessionController>();
    final controller = Get.find<HomeController>();

    return AppShell(
      child: Obx(() {
        if (!session.isLoggedIn) {
          return const AppEmptyState(
            title: '欢迎来到 ShoeCloud',
            subtitle: '先登录并绑定第一双跑鞋，再开始整理你的鞋库与活动记录。',
            icon: Icons.checkroom_outlined,
            action: AddShoeEntryButton(label: true),
          );
        }

        final profile = session.profile.value;
        if (profile == null || controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profile.accountSummary.shoesCount == 0) {
          return const AppEmptyState(
            title: '鞋库还是空的',
            subtitle: '先从预置鞋库里挑一双，补全信息后加入你的个人鞋库。',
            icon: Icons.checkroom_outlined,
            action: AddShoeEntryButton(label: true),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAll,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: HomeHeader()),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final shoe = controller.shoes[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      AppRoutes.shoeDetail,
                      arguments: {'shoe': shoe},
                    ),
                    child: ShoeOverviewCard(shoe: shoe),
                  );
                }, childCount: controller.shoes.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),
        );
      }),
    );
  }
}
