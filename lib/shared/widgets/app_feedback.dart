/// 统一处理轻量级 Snackbar 反馈提示。
import 'package:flutter/material.dart';
import 'package:shoecloud/app/theme/app_theme.dart';

class AppFeedback {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.primaryDeep);
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.danger);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.text);
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
