/// 声明新路由图中的全部运行页面。
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/features/auth/presentation/pages/login_page.dart';
import 'package:shoecloud/features/common/presentation/pages/coming_soon_page.dart';
import 'package:shoecloud/features/main/presentation/pages/main_page.dart';
import 'package:shoecloud/features/privacy/presentation/pages/privacy_page.dart';
import 'package:shoecloud/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:shoecloud/features/shoes/presentation/pages/shoe_activities_page.dart';
import 'package:shoecloud/features/shoes/presentation/pages/shoe_catalog_detail_page.dart';
import 'package:shoecloud/features/shoes/presentation/pages/shoe_catalog_page.dart';
import 'package:shoecloud/features/shoes/presentation/pages/shoe_create_page.dart';
import 'package:shoecloud/features/shoes/presentation/pages/shoe_detail_page.dart';
import 'package:shoecloud/features/shoes/presentation/pages/shoe_edit_page.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.root, page: () => const MainPage()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.catalog, page: () => const ShoeCatalogPage()),
    GetPage(
      name: AppRoutes.catalogDetail,
      page: () => const ShoeCatalogDetailPage(),
    ),
    GetPage(name: AppRoutes.createShoe, page: () => const ShoeCreatePage()),
    GetPage(name: AppRoutes.shoeDetail, page: () => const ShoeDetailPage()),
    GetPage(name: AppRoutes.editShoe, page: () => const ShoeEditPage()),
    GetPage(name: AppRoutes.activities, page: () => const ShoeActivitiesPage()),
    GetPage(name: AppRoutes.profileEdit, page: () => const ProfileEditPage()),
    GetPage(name: AppRoutes.privacy, page: () => const PrivacyPage()),
    GetPage(
      name: AppRoutes.comingSoon,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return ComingSoonPage(title: args?['title']?.toString() ?? '功能开发中');
      },
    ),
  ];
}
