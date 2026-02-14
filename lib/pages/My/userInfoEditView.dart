import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/components/My/userInfoEdit/baseInfoTab.dart';
import 'package:shoecloud/components/My/userInfoEdit/physicalStatsTab.dart';
import 'package:shoecloud/stores/userController.dart';

// 用户信息编辑视图类，继承自 StatefulWidget
class userInfoEditView extends StatefulWidget {
  const userInfoEditView({super.key});

  @override
  State<userInfoEditView> createState() => _userInfoEditViewState();
}

// 用户信息编辑视图的状态类，继承自 State
class _userInfoEditViewState extends State<userInfoEditView> {
  final UserController _userController = Get.find(); // 获取 UserController 实例
  final PageController _pageController =
      PageController(); // 创建 PageController 实例
  int _activeTab = 0; // 当前激活的标签页索引

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // 设置背景颜色
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 设置 AppBar 背景颜色为透明
        elevation: 0, // 设置 AppBar 的阴影高度为 0
        centerTitle: true, // 标题居中显示
        title: const Text(
          "个人档案", // AppBar 标题文本
          style: TextStyle(
            color: Color(0xFF2E7D32), // 标题文本颜色
            fontWeight: FontWeight.bold, // 标题文本加粗
            fontSize: 18, // 标题文本字体大小
          ),
        ),
      ),
      body: Obx(() {
        if (_userController.fullInfo.value == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2E7D32),
            ), // 显示加载中的圆形进度条
          );
        }

        final fullInfo = _userController.fullInfo.value!; // 获取用户完整信息
        return Column(
          children: [
            _buildTabSwitcher(), // 构建标签页切换器
            Expanded(
              child: PageView(
                controller: _pageController, // 使用 PageController 控制标签页切换
                onPageChanged: (index) =>
                    setState(() => _activeTab = index), // 当页面改变时更新激活的标签页索引
                children: [
                  baseInfoTab(base: fullInfo.baseInfo), // 基础资料标签页
                  physicalStatsTab(stats: fullInfo.physicalStats), // 身体数据标签页
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // 构建标签页切换器
  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ), // 设置外部边距
      padding: const EdgeInsets.all(5), // 设置内部边距
      height: 50, // 设置容器高度
      decoration: BoxDecoration(
        color: Colors.white, // 设置容器背景颜色
        borderRadius: BorderRadius.circular(25), // 设置容器圆角
      ),
      child: Row(
        children: [_buildTabBtn("基础资料", 0), _buildTabBtn("身体数据", 1)],
      ), // 添加标签按钮
    );
  }

  // 构建标签按钮
  Widget _buildTabBtn(String title, int index) {
    bool isSelected = _activeTab == index; // 判断当前按钮是否被选中
    return Expanded(
      child: GestureDetector(
        onTap: () => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300), // 设置动画持续时间为 300 毫秒
          curve: Curves.easeInOut, // 设置动画曲线为 easeInOut
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300), // 设置动画持续时间为 300 毫秒
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFF9C4)
                : Colors.transparent, // 设置选中时的背景颜色
            borderRadius: BorderRadius.circular(20), // 设置背景圆角
          ),
          alignment: Alignment.center, // 文本居中
          child: Text(
            title, // 按钮文本
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF2E7D32)
                  : Colors.grey, // 设置选中时的文本颜色
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.normal, // 设置选中时的文本加粗
            ),
          ),
        ),
      ),
    );
  }
}
