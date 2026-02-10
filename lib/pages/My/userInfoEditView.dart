import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/components/My/userInfoEdit/baseInfoTab.dart';
import 'package:shoecloud/components/My/userInfoEdit/physicalStatsTab.dart';
import 'package:shoecloud/stores/userController.dart';

class userInfoEditView extends StatefulWidget {
  const userInfoEditView({super.key});

  @override
  State<userInfoEditView> createState() => _userInfoEditViewState();
}

class _userInfoEditViewState extends State<userInfoEditView> {
  final UserController _userController = Get.find();
  final PageController _pageController = PageController();
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "个人档案",
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (_userController.fullInfo.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
          );
        }

        final fullInfo = _userController.fullInfo.value!;
        return Column(
          children: [
            _buildTabSwitcher(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _activeTab = index),
                children: [
                  baseInfoTab(base: fullInfo.baseInfo),
                  physicalStatsTab(stats: fullInfo.physicalStats),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      padding: const EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(children: [_buildTabBtn("基础资料", 0), _buildTabBtn("身体数据", 1)]),
    );
  }

  Widget _buildTabBtn(String title, int index) {
    bool isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF9C4) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
