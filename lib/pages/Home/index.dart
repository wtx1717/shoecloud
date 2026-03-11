import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shoecloud/api/shoeInfo.dart';
import 'package:shoecloud/components/Home/firstuse/first.dart';
import 'package:shoecloud/components/Home/normal/expandableCategoryBar.dart';
import 'package:shoecloud/components/Home/normal/shoeOverviewCard.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';
import 'package:shoecloud/stores/tokenManager.dart';
import 'package:shoecloud/stores/userController.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

//这里View的含义表示这是首页视图而非Widget组件
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final UserController _userController = Get.find();
  List<ShoeInfo> _shoesList = [];
  bool _isDetailsLoading = true;

  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var info = _userController.fullInfo.value;
      if (tokenManager.getToken().isEmpty) return firstUse();
      if (info == null) return const Center(child: CircularProgressIndicator());
      if (info.accountSummary.shoesCount == 0) return firstUse();

      // 如果正在加载，显示转圈圈
      if (_shoesList.isEmpty && _isDetailsLoading) {
        _loadShoeData(); 
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }

      // 【关键修改】使用 RefreshIndicator 实现下拉刷新
      return RefreshIndicator(
        onRefresh: onRefresh, // 绑定下拉动作
        color: const Color(0xFF2E7D32),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // 确保内容不满也能下拉
          slivers: _getScrollViewSlivers()
        ),
      );
    });
  }

  //获取滚动组件
  List<Widget> _getScrollViewSlivers() {
    return [
      // 顶部分类栏悬停效果
      SliverFloatingHeader(child: expandableCategoryBar()),
      SliverToBoxAdapter(child: SizedBox(height: 10)),

      // 跑鞋概览卡片
      // 使用 SliverList 实现懒加载
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return clickableWrapper(
              route: "shoeInfo_User",
              // 将当前卡片的 shoeId 以 Map 形式作为 arguments 传递到详情页，方便扩展更多参数。
              arguments: {"shoeInfo": _shoesList[index]},
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: shoeOverviewCard(
                  shoeName: _shoesList[index].shoeName,
                  nickName: _shoesList[index].nickname,
                  totalDistance: _shoesList[index].stats.totalMileage
                      .toString(),
                  totalTime: _shoesList[index].stats.totalDuration,
                  imageUrl: _shoesList[index].imageUrl,
                ),
              ),
            );
          },
          childCount: _shoesList.length,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 100)),
    ];
  }

  // 获取跑鞋详情的异步方法
  Future<void> _loadShoeData() async {
    try {
      final list = await getShoeInfoAPI(
        _userController.fullInfo.value!.resources.shoesList,
      );

      if (mounted) {
        setState(() {
          _shoesList = list;
          _isDetailsLoading = false; // 标记加载完成
        });
      }
    } catch (e) {
      debugPrint("获取跑鞋详情失败: $e");
      if (mounted) setState(() => _isDetailsLoading = false);
    }
  }

  // 【新增】提供给外部或下拉刷新的统一入口
  Future<void> onRefresh() async {
    if (mounted) {
      setState(() {
        _isDetailsLoading = true;
        _shoesList = []; // 清空旧数据，强制显示加载动画
      });
    }
    
    // 1. 先刷 UserController 的基础信息
    await _userController.refreshUserInfo();
    
    // 2. 再刷详情（这会调用你原本的 _loadShoeData 逻辑）
    await _loadShoeData();
  }
}
