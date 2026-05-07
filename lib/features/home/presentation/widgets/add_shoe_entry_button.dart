/// 复用添加跑鞋入口，并根据登录状态跳转。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';

class AddShoeEntryButton extends StatelessWidget {
  const AddShoeEntryButton({super.key, this.label = false});

  final bool label;

  @override
  Widget build(BuildContext context) {
    final session = Get.find<AppSessionController>();
    final route = session.isLoggedIn ? AppRoutes.catalog : AppRoutes.login;

    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        width: label ? null : 50,
        height: label ? null : 50,
        padding: EdgeInsets.symmetric(
          horizontal: label ? 16 : 0,
          vertical: label ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: label
            ? const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '添加跑鞋',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            : const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
