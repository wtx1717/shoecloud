/// 通过新的服务层编辑用户资料与身体数据。
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/features/profile/domain/profile_service.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/shared/widgets/app_card.dart';
import 'package:shoecloud/shared/widgets/app_feedback.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _session = Get.find<AppSessionController>();
  final _service = Get.find<ProfileService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = _session.profile.value;
      if (profile == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(title: const Text('个人档案')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section(
              '基础资料',
              [
                _EditTile(
                  label: '用户名',
                  value: profile.baseInfo.userName,
                  onTap: () => _textEdit(
                    title: '修改用户名',
                    initialValue: profile.baseInfo.userName,
                    field: 'userName',
                    keyboardType: TextInputType.text,
                  ),
                ),
                _EditTile(
                  label: '账号',
                  value: profile.baseInfo.account,
                  enabled: false,
                ),
                _EditTile(
                  label: '性别',
                  value: profile.baseInfo.gender,
                  onTap: _genderEdit,
                ),
                _EditTile(
                  label: '生日',
                  value: profile.baseInfo.birthday,
                  onTap: _birthdayEdit,
                ),
                _EditTile(
                  label: '注册日期',
                  value: profile.baseInfo.registerDate,
                  enabled: false,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _section(
              '身体数据',
              [
                _EditTile(
                  label: '身高',
                  value:
                      '${profile.physicalStats.height} ${profile.physicalStats.unit['height'] ?? 'cm'}',
                  onTap: () => _numberEdit(
                    title: '修改身高',
                    initialValue: profile.physicalStats.height,
                    field: 'height',
                  ),
                ),
                _EditTile(
                  label: '体重',
                  value:
                      '${profile.physicalStats.weight} ${profile.physicalStats.unit['weight'] ?? 'kg'}',
                  onTap: () => _numberEdit(
                    title: '修改体重',
                    initialValue: profile.physicalStats.weight,
                    field: 'weight',
                  ),
                ),
                _EditTile(
                  label: '鞋码',
                  value:
                      '${profile.physicalStats.shoeSize} ${profile.physicalStats.unit['shoeSize'] ?? 'EUR'}',
                  onTap: () => _numberEdit(
                    title: '修改鞋码',
                    initialValue: profile.physicalStats.shoeSize,
                    field: 'shoeSize',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () async {
                await _service.logout();
                if (!mounted) {
                  return;
                }
                AppFeedback.showSuccess(context, '已退出登录');
                Get.back();
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                '退出登录',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _section(String title, List<Widget> children) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Future<void> _genderEdit() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('选择性别'),
        actions: ['男', '女', '未知']
            .map(
              (item) => CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(context);
                  await _saveField(field: 'gender', value: item);
                },
                child: Text(item),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ),
    );
  }

  Future<void> _birthdayEdit() async {
    var selected = DateTime.tryParse(
          _session.profile.value?.baseInfo.birthday ?? '',
        ) ??
        DateTime(2000, 1, 1);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 320,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final value =
                        '${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
                    await _saveField(field: 'birthday', value: value);
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selected,
                onDateTimeChanged: (value) => selected = value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _textEdit({
    required String title,
    required String initialValue,
    required String field,
    required TextInputType keyboardType,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _saveField(field: field, value: controller.text.trim());
    }
  }

  Future<void> _numberEdit({
    required String title,
    required double initialValue,
    required String field,
  }) async {
    final controller = TextEditingController(text: initialValue.toString());
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _saveField(
        field: field,
        value: double.tryParse(controller.text) ?? initialValue,
      );
    }
  }

  Future<void> _saveField({
    required String field,
    required dynamic value,
  }) async {
    final success = await _service.updateField(field: field, value: value);
    if (!mounted) {
      return;
    }

    if (success) {
      AppFeedback.showSuccess(context, '信息已更新');
    } else {
      AppFeedback.showError(context, '更新失败');
    }
  }
}

class _EditTile extends StatelessWidget {
  const _EditTile({
    required this.label,
    required this.value,
    this.onTap,
    this.enabled = true,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            Flexible(
              child: Text(
                value.isEmpty ? '未填写' : value,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            if (enabled) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
            ],
          ],
        ),
      ),
    );
  }
}
