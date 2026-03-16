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
    // 获取路由参数
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
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => _showConfirmDialog(args),
          child: const Text(
            "添加该跑鞋",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  // --- 重构后的 UI 统一风格弹窗 ---
  void _showConfirmDialog(Map<String, dynamic> args) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(0xFFE8F5E9), // 浅绿背景
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 自适应内容高度
              children: [
                // 顶部图标装饰：森林绿圆底
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFC8E6C9), // 浅绿圆底
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_shopping_cart_rounded,
                    size: 40,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 20),

                // 标题
                const Text(
                  "确认添加",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 12),

                // 描述文字
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(color: Colors.grey, height: 1.5),
                    children: [
                      const TextSpan(text: "确定要将 "),
                      TextSpan(
                        text: "${args['name']}",
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: "\n加入您的鞋库吗？"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 确认按钮 (使用包装的 clickableWrapper)
                SizedBox(
                  width: double.infinity,
                  child: clickableWrapper(
                    route: "shoeEditView",
                    arguments: args,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "去编辑",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 取消按钮
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text(
                    "再想想",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
