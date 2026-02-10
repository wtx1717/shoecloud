import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shoecloud/components/common/clickableWrapper.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/banner.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/infoCard.dart';

class shoeInfo_AddView extends StatefulWidget {
  const shoeInfo_AddView({super.key});

  @override
  State<shoeInfo_AddView> createState() => _shoeInfo_AddViewState();
}

class _shoeInfo_AddViewState extends State<shoeInfo_AddView> {
  @override
  Widget build(BuildContext context) {
    // 原生方式获取路由参数
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 30),
                    _buildBanner(args),
                    const SizedBox(height: 25),
                    _buildInfoCard(args),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildBottomAction(args),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0.4),
      title: const Text(
        '跑鞋详情',
        style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
    );
  }

  Widget _buildBanner(Map<String, dynamic> args) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: bannerShoeInfo_Add(imagesUrl: args['imagesUrl']),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> args) {
    return cardShoeInfo_Add(
      name: args['name'],
      brand: args['brand'],
      release_price: args['release_price'],
      release_year: args['release_year'],
      features: args['features'],
      description: args['description'],
      category: args['category'],
    );
  }

  Widget _buildBottomAction(Map<String, dynamic> args) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => _showConfirmDialog(args),
          child: const Text(
            "添加该跑鞋",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // 关键修改：弹窗中使用 clickableWrapper
  void _showConfirmDialog(Map<String, dynamic> args) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text(
          "确认添加",
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text("确定要将 ${args['name']} 加入您的鞋库吗？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("再想想", style: TextStyle(color: Colors.grey)),
          ),
          // 使用你封装的跳转组件
          clickableWrapper(
            route: "shoeEditView",
            arguments: args, // 确保你的 wrapper 支持传参
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                "去编辑",
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
