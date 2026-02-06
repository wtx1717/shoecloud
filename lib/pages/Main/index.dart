import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shoecloud/pages/Home/index.dart';
import 'package:shoecloud/pages/My/index.dart';
import 'package:shoecloud/pages/Social/index.dart';

// 主页面类，继承自 StatefulWidget，用于展示底部导航栏和对应页面
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// 主页面的状态类，继承自 State<MainPage>
class _MainPageState extends State<MainPage> {
  //监听app启动时是否是通过appLink打开
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initNfcReceiver();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel(); // 记得销毁，防止内存泄漏
    super.dispose();
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

  //初始化 NFC 接收器
  void _initNfcReceiver() async {
    // 1. 处理从“完全关闭”状态被 NFC 唤醒的情况
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) _handleDeepLink(initialLink);

    // 2. 处理 App 在后台时被 NFC 唤醒的情况
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  // 在类级别定义两个变量
  String? _lastProcessedId;
  DateTime? _lastProcessTime;
  //处理从 NFC 唤醒 App 的情况
  void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'shoecloud' && uri.host == 'bind') {
      final shoeId = uri.pathSegments.last;

      // --- 防抖逻辑开始 ---
      final now = DateTime.now();
      // 如果 ID 一样，且两次触发间隔小于 1 秒，就认为是重复触发
      if (_lastProcessedId == shoeId &&
          _lastProcessTime != null &&
          now.difference(_lastProcessTime!).inMilliseconds < 1000) {
        print("【NFC调试】检测到重复触发，已拦截");
        return;
      }

      _lastProcessedId = shoeId;
      _lastProcessTime = now;
      // --- 防抖逻辑结束 ---

      print('【NFC调试】准备跳转，携带ID: $shoeId');

      if (context.mounted) {
        Navigator.pushNamed(context, "/shoeInfo_User", arguments: shoeId);
      }
    }
  }
}
