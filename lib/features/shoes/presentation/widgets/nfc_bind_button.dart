/// 触发当前跑鞋的 NFC 绑定流程。
import 'package:flutter/material.dart';
import 'package:shoecloud/app/theme/app_theme.dart';
import 'package:shoecloud/core/nfc/nfc_writer.dart';
import 'package:shoecloud/shared/widgets/app_feedback.dart';
import 'package:shoecloud/shared/widgets/app_primary_button.dart';

class NfcBindButton extends StatelessWidget {
  const NfcBindButton({
    super.key,
    required this.shoeId,
    required this.userId,
  });

  final String shoeId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: AppPrimaryButton(
        label: '绑定 NFC',
        icon: Icons.nfc_rounded,
        onPressed: () => _showSheet(context),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 132,
                height: 132,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nfc_rounded,
                  size: 64,
                  color: AppColors.primaryDeep,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '跑鞋 NFC 绑定',
                style: TextStyle(
                  color: AppColors.primaryDeep,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '请确认手机 NFC 已开启，再将手机背部贴近跑鞋芯片。',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, height: 1.5),
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: '开始写入',
                onPressed: () async {
                  Navigator.pop(context);
                  await _write(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _write(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在等待 NFC 芯片感应...'),
            ],
          ),
        ),
      ),
    );

    try {
      await NfcWriter.write(shoeId: shoeId, userId: userId);
      if (context.mounted) {
        Navigator.pop(context);
        AppFeedback.showSuccess(context, 'NFC 绑定成功');
      }
    } catch (_) {
      if (context.mounted) {
        Navigator.pop(context);
        AppFeedback.showError(context, 'NFC 写入失败');
      }
    }
  }
}
