import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoecloud/api/shoeInfo.dart'; // 确保导入了 getSingleShoeByIdAPI
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
  bool _hasAutoSynced = false; // 状态锁，防止页面刷新时重复触发

  ShoeInfo? _currentShoe; // 用于管理当前显示的鞋子数据
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _currentShoe = args?['shoeInfo'] as ShoeInfo?;

      // --- 伟大的一步：检测 NFC 信号并自动同步 ---
      bool fromNfc = args?['fromNfc'] ?? false;

      if (fromNfc && !_hasAutoSynced) {
        _hasAutoSynced = true;

        // 使用 PostFrameCallback 确保页面 UI 渲染完再弹窗，避免 context 报错
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 增加一点仪式感提示
          _showSafeToast("NFC 感应成功，正在检查运动记录...");
          _handleSyncFlow(); // 执行我们写好的同步大逻辑
        });
      }

      _isInitialized = true;
    }
  }

  // 下拉刷新的核心逻辑
  Future<void> _handleRefresh() async {
    if (_currentShoe == null) return;

    // 1. 调用单条查询接口（自带时间戳，破除缓存）
    final updatedData = await getSingleShoeByIdAPI(_currentShoe!.shoeId);

    if (updatedData != null) {
      setState(() {
        _currentShoe = updatedData;
      });
      // 2. 同时静默刷新全局列表，确保回到首页也是新的
      await _userController.refreshUserInfo();
    } else {
      Get.snackbar("提示", "获取最新数据失败，请检查网络", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // 跳转编辑页并监听返回
  void _navigateToEdit() async {
    // 这里的 result 就是我们在编辑页 pop(true) 传回来的值
    final result = await Navigator.pushNamed(
      context,
      '/shoe_edit',
      arguments: {'shoeInfo': _currentShoe},
    );

    // 如果编辑页告诉我们要刷新，或者返回了 true
    if (result == true) {
      // 自动触发下拉刷新动画
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
      // --- 下拉刷新组件 ---
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: const Color(0xFF2E7D32),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          // 关键：必须使用 AlwaysScrollableScrollPhysics 确保内容较少时也能下拉
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              shoeHeroHeader(shoe: _currentShoe!),
              shoeStatsGrid(shoe: _currentShoe!),
              shoeFeatureTags(features: _currentShoe!.features),
              shoeDetailList(shoe: _currentShoe!),

              SizedBox(height: 30),
              syncActionCard(
                isLoading: _isSyncing, // 你可以在 State 里定义一个 bool 变量
                onTap: _handleSyncFlow,
              ),

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

  // 在 _shoeInfo_UserViewState 中
  Future<void> _handleSyncFlow() async {
    // 手机震动一下，给用户反馈
    HapticFeedback.mediumImpact();

    setState(() => _isSyncing = true);

    try {
      final String userId = _userController.fullInfo.value!.baseInfo.userId;
      final String shoeId = _currentShoe!.shoeId;

      final checkResult = await checkPendingActivitiesAPI(userId: userId);
      print("后端原始返回: $checkResult");

      // --- 关键防御性代码 ---
      if (checkResult == null) {
        _showSafeToast("网络请求失败");
        return;
      }

      final resultData = checkResult;
      // 使用 ?? [] 确保即使后端没传这个字段，也会得到一个空列表而不是 null
      List activities = resultData['activities'] ?? [];
      int count = resultData['count'] ?? 0;

      if (count == 0 || activities.isEmpty) {
        _showSimpleAlert("暂无活动", "当前目录下没有发现待同步的活动文件。");
        return;
      }

      if (count == 1) {
        // 单个文件同步
        final String fileName = activities[0]['file_name']; // 注意这里现在是 Map 结构了
        final syncRes = await moveSingleActivityAPI(
          userId: userId,
          shoeId: shoeId,
          fileName: fileName,
        );

        if (syncRes != null) {
          _showSafeToast("同步成功！");
          await _handleRefresh();
        }
      } else {
        // 多个文件，弹出我们新写的那个 Sheet
        _showMultiActivitiesDialog(activities);
      }
    } catch (e) {
      print("同步逻辑报错: $e");
      _showSafeToast("发生错误: $e");
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  // 简单的警告弹窗封装
  void _showSimpleAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("好"),
          ),
        ],
      ),
    );
  }

  // 封装的大弹窗逻辑
  void _showMultiActivitiesDialog(List activities) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许高度自定义
      backgroundColor: Colors.transparent, // 配合组件的圆角
      builder: (context) => ActivitySelectionSheet(
        activities: activities,
        onSync: (fileName) async {
          // 这里的逻辑和你单文件同步一模一样
          final syncRes = await moveSingleActivityAPI(
            userId: _userController.fullInfo.value!.baseInfo.userId,
            shoeId: _currentShoe!.shoeId,
            fileName: fileName,
          );
          if (syncRes != null) {
            _showSafeToast("活动已同步！");
            _handleRefresh(); // 刷新页面数据
          }
        },
      ),
    );
  }

  // 之前封装的简单提示
  void _showSafeToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
