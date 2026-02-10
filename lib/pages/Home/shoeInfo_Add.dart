import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/banner.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/bindNFCBottom.dart';
import 'package:shoecloud/components/Home/addNewShoe/shoeInfo_Add/infoCard.dart';

class shoeInfo_AddView extends StatefulWidget {
  const shoeInfo_AddView({super.key});

  @override
  State<shoeInfo_AddView> createState() => _shoeInfo_AddViewState();
}

class _shoeInfo_AddViewState extends State<shoeInfo_AddView> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      // 使用云鞋库标志性底色
      backgroundColor: const Color(0xFFE8F5E9),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.4),
        title: const Text(
          '绑定新跑鞋',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        // 毛玻璃效果顶栏
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: SafeArea(
        top: false, // 让内容可以延伸到状态栏下方
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 30),

                    // 轮播图 - 增加呼吸感边距和圆角
                    Padding(
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
                          child: bannerShoeInfo_Add(
                            imagesUrl: args['imagesUrl'],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 信息卡片
                    cardShoeInfo_Add(
                      name: args['name'],
                      brand: args['brand'],
                      release_price: args['release_price'],
                      release_year: args['release_year'],
                      features: args['features'],
                      description: args['description'],
                      category: args['category'],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 底部绑定动作区 - 简化为单一按钮
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
              child: bindNFCBottom(
                shoeId: args['id']?.toString() ?? "0",
                userId: "0", // 这里的userId建议后续从全局状态获取
              ),
            ),
          ],
        ),
      ),
    );
  }
}
