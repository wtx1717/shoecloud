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

      if (tokenManager.getToken().isEmpty) {
        return firstUse();
      }

      // 第一层闸门：等用户信息
      if (info == null) {
        return const Center(child: CircularProgressIndicator());
      }

      // 如果没鞋子，直接去新手引导
      if (info.accountSummary.shoesCount == 0) {
        return firstUse();
      }

      // 第二层闸门：用户信息有了，但详情数据还没回来
      // 我们在第一次监听到 info 有值时，去触发加载详情
      if (_shoesList.isEmpty && _isDetailsLoading) {
        _loadShoeData(); // 异步获取详情
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }

      // 第三层：数据全齐了，展示滚动列表
      return CustomScrollView(slivers: _getScrollViewSlivers());
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
          childCount: _userController.fullInfo.value?.accountSummary.shoesCount,
        ),
      ),
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
}
