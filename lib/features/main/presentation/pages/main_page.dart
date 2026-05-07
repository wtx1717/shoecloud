/// 承载底部导航主壳，并初始化会话与深链状态。
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/core/nfc/deep_link_nfc_manager.dart';
import 'package:shoecloud/features/home/presentation/controllers/home_controller.dart';
import 'package:shoecloud/features/home/presentation/pages/home_page.dart';
import 'package:shoecloud/features/profile/presentation/pages/profile_page.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/features/social/presentation/pages/social_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _session = Get.find<AppSessionController>();
  final _homeController = Get.find<HomeController>();
  final _nfcManager = Get.find<DeepLinkNfcManager>();
  int _currentIndex = 0;

  final _tabs = const [HomePage(), SocialPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _session.bootstrap();
    await _homeController.load();
    await _nfcManager.init();
  }

  @override
  void dispose() {
    _nfcManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_session.isBootstrapping.value) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _tabs),
        bottomNavigationBar: _buildBottomBar(),
      );
    });
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.checkroom_outlined),
                activeIcon: Icon(Icons.checkroom),
                label: '鞋库',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                activeIcon: Icon(Icons.grid_view),
                label: '社区',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: '我的',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
