import 'package:flutter/material.dart';
import 'package:shoecloud/pages/Home/index.dart';
import 'package:shoecloud/pages/My/index.dart';
import 'package:shoecloud/pages/Social/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //定义当前选中的导航索引
  int _currentIndex = 0;
  //定义数据，根据数据渲染三个导航
  final List<Map<String, String>> _tabList = [
    {
      "title": "鞋库",
      "icon": "lib/assets/bottom_nav/home_normal.png", //正常显示的图标
      "activeIcon": "lib/assets/bottom_nav/home_active.png", //激活显示的图标
    },
    {
      "title": "社区",
      "icon": "lib/assets/bottom_nav/social_normal.png",
      "activeIcon": "lib/assets/bottom_nav/social_normal.png",
    },
    {
      "title": "我的",
      "icon": "lib/assets/bottom_nav/my_normal.png",
      "activeIcon": "lib/assets/bottom_nav/my_normal.png",
    },
  ];

  //根据数据生成BottomNavigationBarItem列表
  List<BottomNavigationBarItem> _getTabBarWidgets() {
    return List.generate(_tabList.length, (index) {
      return BottomNavigationBarItem(
        icon: Image.asset(_tabList[index]["icon"]!, width: 24, height: 24),
        activeIcon: Image.asset(
          _tabList[index]["activeIcon"]!,
          width: 24,
          height: 24,
        ),
        label: _tabList[index]["title"],
      );
    });
  }

  //根据数据生成页面列表
  List<Widget> _getTabBarPages() {
    return [HomeView(), SocialView(), MyView()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SafeArea避免刘海屏遮挡
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _getTabBarPages()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          _currentIndex = index;
          setState(() {});
        },
        selectedItemColor: Colors.blue,
        currentIndex: _currentIndex,
        items: _getTabBarWidgets(),
      ),
    );
  }
}
