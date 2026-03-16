import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoecloud/api/shoeInfo.dart';
import 'package:shoecloud/api/syncActivity.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/bindNFCBottom.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/activitySelectionSheet.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeDetailList.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeFeatureTags.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeHeroHeader.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeStatsGrid.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/syncActionCard.dart';
import 'package:shoecloud/stores/userController.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

class shoeInfo_UserView extends StatefulWidget {
  const shoeInfo_UserView({super.key});

  @override
  State<shoeInfo_UserView> createState() => _shoeInfo_UserViewState();
}

class _shoeInfo_UserViewState extends State<shoeInfo_UserView> {
  final UserController _userController = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isSyncing = false;
  bool _hasAutoSynced = false;

  ShoeInfo? _currentShoe;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _currentShoe = args?['shoeInfo'] as ShoeInfo?;

      bool fromNfc = args?['fromNfc'] ?? false;
      if (fromNfc && !_hasAutoSynced) {
        _hasAutoSynced = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSafeToast("NFC 感应成功，正在检查运动记录...");
          _handleSyncFlow();
        });
      }
      _isInitialized = true;
    }
  }

  Future<void> _handleRefresh() async {
    if (_currentShoe == null) return;
    final updatedData = await getSingleShoeByIdAPI(_currentShoe!.shoeId);
    if (updatedData != null) {
      setState(() {
        _currentShoe = updatedData;
      });
      await _userController.refreshUserInfo();
    }
  }

  void _navigateToEdit() async {
    final result = await Navigator.pushNamed(
      context,
      '/shoe_edit',
      arguments: {'shoeInfo': _currentShoe},
    );
    if (result == true) {
      _refreshIndicatorKey.currentState?.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentShoe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("详情")),
        body: const Center(child: Text("数据加载失败")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: Text(
          _currentShoe!.shoeName,
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Color(0xFF2E7D32)),
            onPressed: _navigateToEdit,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: const Color(0xFF2E7D32),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              shoeHeroHeader(shoe: _currentShoe!),
              shoeStatsGrid(shoe: _currentShoe!),
              shoeFeatureTags(features: _currentShoe!.features),
              shoeDetailList(shoe: _currentShoe!),
              const SizedBox(height: 30),
              syncActionCard(isLoading: _isSyncing, onTap: _handleSyncFlow),
              const SizedBox(height: 30),
              bindNFCBottom(
                shoeId: _currentShoe!.shoeId,
                userId: _userController.fullInfo.value!.baseInfo.userId,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSyncFlow() async {
    HapticFeedback.mediumImpact();
    setState(() => _isSyncing = true);

    try {
      final String userId = _userController.fullInfo.value!.baseInfo.userId;
      final String shoeId = _currentShoe!.shoeId;

      final checkResult = await checkPendingActivitiesAPI(userId: userId);

      if (checkResult == null) {
        _showSafeToast("网络连接异常，请重试");
        return;
      }

      List activities = checkResult['activities'] ?? [];
      int count = checkResult['count'] ?? 0;

      if (count == 0 || activities.isEmpty) {
        _showNoActivityStatus();
        return;
      }

      if (count == 1) {
        // 单个活动同步：保留仪式感弹窗
        final String fileName = activities[0]['file_name'];
        final syncRes = await moveSingleActivityAPI(
          userId: userId,
          shoeId: shoeId,
          fileName: fileName,
        );

        if (syncRes != null) {
          _showSyncSuccessUI();
          await _handleRefresh();
        }
      } else {
        // 多个活动：进入连续同步模式
        _showMultiActivitiesDialog(activities);
      }
    } catch (e) {
      _showSafeToast("发生错误: $e");
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  void _showMultiActivitiesDialog(List activities) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivitySelectionSheet(
        activities: activities,
        onSync: (fileName) async {
          final syncRes = await moveSingleActivityAPI(
            userId: _userController.fullInfo.value!.baseInfo.userId,
            shoeId: _currentShoe!.shoeId,
            fileName: fileName,
          );
          if (syncRes != null) {
            // --- 核心优化逻辑 ---
            // 多选模式下不弹出 Dialog 遮挡，而是用 Toast 告知结果，并静默刷新列表
            HapticFeedback.lightImpact();
            _showSafeToast("已同步活动：$fileName");
            _handleRefresh();
          }
        },
      ),
    );
  }

  // --- 风格对齐：暂无活动弹窗 ---
  void _showNoActivityStatus() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFFE8F5E9),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF9C4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 40,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "暂无待处理记录",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "服务器中没有发现您的运动记录\n请确认运动已结束并上传",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("好 的"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 风格对齐：同步成功弹窗 (用于单次同步) ---
  void _showSyncSuccessUI() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFFE8F5E9),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF9C4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 40,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "同步成功",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "运动数据已成功记录\n跑鞋寿命已为您实时更新",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("太 棒 了"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSafeToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          40,
        ), // 让 Toast 飘得高一点，避免挡住底栏操作
      ),
    );
  }
}
