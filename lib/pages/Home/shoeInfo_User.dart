import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/api/shoeInfo.dart'; // 确保导入了 getSingleShoeByIdAPI
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/bindNFCBottom.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeDetailList.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeFeatureTags.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeHeroHeader.dart';
import 'package:shoecloud/components/Home/shoeInfo_user/shoeStatsGrid.dart';
import 'package:shoecloud/stores/userController.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

class shoeInfo_UserView extends StatefulWidget {
  const shoeInfo_UserView({super.key});

  @override
  State<shoeInfo_UserView> createState() => _shoeInfo_UserViewState();
}

class _shoeInfo_UserViewState extends State<shoeInfo_UserView> {
  final UserController _userController = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  ShoeInfo? _currentShoe; // 用于管理当前显示的鞋子数据
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 仅在初始化时从路由获取一次数据
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _currentShoe = args?['shoeInfo'] as ShoeInfo?;
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
      arguments: {'shoeInfo': _currentShoe}
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
          style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Color(0xFF2E7D32)),
            onPressed: _navigateToEdit,
          )
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
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            children: [
              shoeHeroHeader(shoe: _currentShoe!),
              shoeStatsGrid(shoe: _currentShoe!),
              shoeFeatureTags(features: _currentShoe!.features),
              shoeDetailList(shoe: _currentShoe!),
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
}