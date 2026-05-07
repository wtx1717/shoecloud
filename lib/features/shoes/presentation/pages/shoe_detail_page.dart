/// 展示跑鞋详情页，并协调同步、刷新与编辑动作。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/app/router/app_routes.dart';
import 'package:shoecloud/features/home/presentation/controllers/home_controller.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/features/shoes/domain/shoe_service.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';
import 'package:shoecloud/features/shoes/presentation/widgets/activity_selection_sheet.dart';
import 'package:shoecloud/features/shoes/presentation/widgets/nfc_bind_button.dart';
import 'package:shoecloud/features/shoes/presentation/widgets/shoe_detail_header.dart';
import 'package:shoecloud/features/shoes/presentation/widgets/shoe_detail_list.dart';
import 'package:shoecloud/features/shoes/presentation/widgets/shoe_stats_card.dart';
import 'package:shoecloud/features/shoes/presentation/widgets/sync_action_card.dart';
import 'package:shoecloud/shared/widgets/app_feedback.dart';

class ShoeDetailPage extends StatefulWidget {
  const ShoeDetailPage({super.key});

  @override
  State<ShoeDetailPage> createState() => _ShoeDetailPageState();
}

class _ShoeDetailPageState extends State<ShoeDetailPage> {
  final _session = Get.find<AppSessionController>();
  final _service = Get.find<ShoeService>();
  final _homeController = Get.find<HomeController>();

  late Shoe _shoe;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    _shoe = args['shoe'] as Shoe;
    final autoSync = args['autoSync'] == true;
    if (autoSync) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncFlow();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _shoe.shoeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final updated = await Get.toNamed(
                AppRoutes.editShoe,
                arguments: {'shoe': _shoe},
              );
              if (updated == true) {
                await _refresh();
              }
            },
            icon: const Icon(Icons.edit_note_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ShoeDetailHeader(shoe: _shoe),
              ShoeStatsCard(shoe: _shoe),
              ShoeDetailList(shoe: _shoe),
              SyncActionCard(isLoading: _isSyncing, onTap: _syncFlow),
              NfcBindButton(shoeId: _shoe.shoeId, userId: _session.userId),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    final updated = await _service.reloadShoe(_shoe.shoeId);
    await _session.refreshUserProfile();
    await _homeController.load();

    if (updated != null && mounted) {
      setState(() => _shoe = updated);
    }
  }

  Future<void> _syncFlow() async {
    setState(() => _isSyncing = true);
    final result = await _service.checkPendingActivities(_session.userId);
    if (!mounted) {
      return;
    }

    if (result == null) {
      setState(() => _isSyncing = false);
      AppFeedback.showError(context, '网络异常，请稍后重试');
      return;
    }

    final activities = result['activities'] as List? ?? const [];
    final count = result['count'] ?? 0;

    if (count == 0 || activities.isEmpty) {
      setState(() => _isSyncing = false);
      AppFeedback.showInfo(context, '暂无待处理活动');
      return;
    }

    if (count == 1) {
      await _syncSingle((activities.first as Map)['file_name'].toString());
      return;
    }

    setState(() => _isSyncing = false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ActivitySelectionSheet(
          activities: activities,
          onSync: _syncSingle,
        );
      },
    );
  }

  Future<void> _syncSingle(String fileName) async {
    final result = await _service.syncActivity(
      userId: _session.userId,
      shoeId: _shoe.shoeId,
      fileName: fileName,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSyncing = false);

    if (result != null) {
      await _refresh();
      AppFeedback.showSuccess(context, '活动已同步');
    } else {
      AppFeedback.showError(context, '同步失败');
    }
  }
}
